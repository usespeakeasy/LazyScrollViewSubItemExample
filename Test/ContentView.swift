//
//  ContentView.swift
//  Test
//
//  Created by Sean Kim on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    let items = Array(0...20) // Example data for main list items
    let subItems = Array(0...5) // Example data for sub-items
    
    @State private var targetMainItem: Int = 0 // Target main item
    @State private var targetSubItem: Int = 0 // Target sub-item
    
    var body: some View {
        VStack {
            HStack {
                Button("Scroll to Main Item 10, Sub-item 3") {
                    scrollToItem(mainItem: 10, subItem: 3)
                }
                Button("Scroll to Main Item 15, Sub-item 2") {
                    scrollToItem(mainItem: 15, subItem: 2)
                }
            }
            .padding()
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10) {
                        ForEach(items, id: \.self) { mainItem in
                            VStack(alignment: .leading) {
                                Text("Main Item \(mainItem)")
                                    .font(.headline)
                                    .padding(.top, 10)
                                    .id(mainItem) // Assign ID to main item

                                // Nesting VStack inside LazyVStack
                                VStack(alignment: .leading) {
                                    ForEach(subItems, id: \.self) { subItem in
                                        Text("Sub-item \(subItem)")
                                            .padding(5)
                                            .background(Color.blue.opacity(0.2))
                                            .id("main\(mainItem)-sub\(subItem)") // Unique ID for sub-items
                                    }
                                }
                                .background(Color.green.opacity(0.1)) // Just to highlight nested VStack
                            }
                        }
                    }
                }
                .onChange(of: targetMainItem) { _ in
                    // First scroll to the main item
                    scrollViewProxy.scrollTo(targetMainItem, anchor: .top)
                    // Then scroll to target with a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let targetId = "main\(targetMainItem)-sub\(targetSubItem)"
                        scrollViewProxy.scrollTo(targetId, anchor: .top)
                    }
                }
            }
        }
    }
    
    // Function to handle scrolling to both main item and sub-item
    private func scrollToItem(mainItem: Int, subItem: Int) {
        targetMainItem = mainItem
        targetSubItem = subItem
    }
}
#Preview {
    ContentView()
}

//
//  ContentView.swift
//  08_animatedSplashScreen
//
//  Created by emm on 08/01/2021.
//

import SwiftUI
import Lottie
import Combine

struct ContentView: View {
    

    var body: some View {
       SplashScreen()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SplashScreen: View {
    
    @State var show = false
    
    // Login Details...
    
    @State var phNo = ""
    @State private var keyboardHeight: CGFloat = 0
    
    
    var body: some View{
        
        VStack {
            
            ZStack {
                Color("bg")
                    .ignoresSafeArea()
                ZStack {
                    VStack {
                AnimatedView(show: $show)
                    // default Frame...
                    .frame(width: 0, height: UIScreen.main.bounds.height / 2)
                    .padding(.bottom, -10)
                        
                    
                    
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 100, height: 200)
                            
                    
                    }
                }
                
//                    .aspectRatio(contentMode: .fit)
                VStack {
                    
                        
                    Spacer()
                    
                     
                    VStack {
                       // vstack white window rect
                        HStack {
                            VStack(alignment: .leading, spacing: 10, content: {
                                Text("Login")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("login"))
                                
                                Text("Enter your phone number to continue")
                                    .foregroundColor(.gray)
                            })
                            
                            Spacer(minLength: 15)
                            
                        }
                        
                        VStack {
                            HStack(spacing: 15){
                                Text("+1")
                                    .foregroundColor(Color("login"))
                                
                                Rectangle()
                                    .fill(Color("bg"))
                                    .frame(width: 1, height: 30)
                                
                                TextField("", text: $phNo)
                                    .foregroundColor(Color("login"))
                                    .keyboardType(.numberPad)
                            }
                            
                            Divider()
                                .background(Color("bg"))
                        }
                        .padding(.vertical)
                        
                        Button(action: {}, label: {
                            Text("Verify your number")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width - 60)
                                .background(Color("bg"))
                                .clipShape(Capsule())
                        })
                        HStack {
                            Rectangle()
                                .fill(Color.primary.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("OR")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.3))
                                .frame(height: 1)
                            
                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical)
                        
                        HStack(spacing: 20) {
                            Button(action: {}, label: {
                                HStack(spacing: 10) {
                                    Image("fb")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                    
                                    Text("facebook")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                                .background(Color("fb"))
                                .clipShape(Capsule())
                            })
                            
                            Button(action: {}, label: {
                                HStack(spacing: 10) {
                                    Image("google")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                    
                                    Text("google")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                                .background(Color("google"))
                                .clipShape(Capsule())
                            })
                        }
                    } // vstack white window rect
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    
                    // padding keyboard on
//                    .padding(.bottom, keyboardHeight)
                    .padding(.horizontal, 10)
                    
                    // push view when keyboard on
                    .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                    
                    // clic screen keyboard hide
                    .onTapGesture {
                        UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                    }
                    
                    // Bottom To up Transition..
                    
                    // we can acheive this by frame property...
//                    .frame(height: show ? nil : 0)
//                    .opacity(show ? 1 : 0)
                }
            }
        }
    }
}



// Animated View...

struct AnimatedView: UIViewRepresentable {
    
    
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> AnimationView {
        
        
        let view = AnimationView(name: "yoga", bundle: Bundle.main)
        
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        
            
        
        // on Complete...
        view.play { (status) in
            if status {
                // toggling view ...
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8)) {
                    show.toggle()
                }
            }
        }
        return view
    }
    
    
    func updateUIView(_ uiView: AnimationView, context: Context) {
        
    }
    
    
}



///////////////////////// extension \\\\\\\\\\\\\\\\\\\
// extension keyboard publisher and notification..... (import Combine)

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

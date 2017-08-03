//
//  ViewController.swift
//  AudioToolBoxModul
//
//  Created by XCODE on 2017/5/12.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    enum ButtonTag: Int {
        case sound = 1, soundAndVibrate, vibrate
    }
    
    var soundFileURL: CFURL!
    var soundFileObject = SystemSoundID()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        func button(frame: CGRect, title: String, tag: ButtonTag) -> UIButton {
            let button = UIButton(frame: frame)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.layer.cornerRadius = 8.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.addTarget(self, action: #selector(self.onButtonAction(_:)), for: .touchUpInside)
            button.tag = tag.rawValue
            return button
        }
        
        let soundButton = button(
            frame: CGRect(x: 40, y: 200, width: UIScreen.main.bounds.width - 80, height: 40),
            title: "音效",
            tag: .sound
        )
        self.view.addSubview(soundButton)
        
        let soundAndVibrateBuuton = button(
            frame: CGRect(x: 40, y: 250, width: UIScreen.main.bounds.width - 80, height: 40),
            title: "音效與震動",
            tag: .soundAndVibrate
        )
        self.view.addSubview(soundAndVibrateBuuton)
        
        let vibrateButton = button(
            frame: CGRect(x: 40, y: 300, width: UIScreen.main.bounds.width - 80, height: 40),
            title: "震動",
            tag: .vibrate
        )
        self.view.addSubview(vibrateButton)
        
        if let path = Bundle.main.path(forResource: "cat01", ofType: "wav") {
            self.soundFileURL = URL(fileURLWithPath: path) as CFURL
            AudioServicesCreateSystemSoundID(self.soundFileURL, &self.soundFileObject)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - selector
    func onButtonAction(_ sender: UIButton) {
        guard let tag = ButtonTag(rawValue: sender.tag) else { return }
        switch tag {
        case .sound:
            AudioServicesPlaySystemSound(self.soundFileObject)
        case .soundAndVibrate:
            AudioServicesPlayAlertSound(self.soundFileObject)
        case .vibrate:
            AudioServicesPlaySystemSound(UInt32(kSystemSoundID_Vibrate))
            self.vibrate(sender)
        }
    }
    
    //MARK: - function
    private func vibrate(_ view: UIView) {
        // core animation
        
        // 參考資料1： https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
        // 參考資料2： http://www.hangge.com/blog/cache/detail_776.html
        
        let layer = view.layer
        let p1 = CGPoint(x: layer.position.x - 2, y: layer.position.y - 2)
        let p2 = CGPoint(x: layer.position.x + 2, y: layer.position.y + 2)
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue.init(cgPoint: p1)
        animation.toValue = NSValue.init(cgPoint: p2)
        animation.autoreverses = true
        animation.duration = 0.03
        animation.repeatCount = 5
        view.layer.add(animation, forKey: "myFrame")
    }

}











Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab3JOVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:22:28 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:65015 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522Ab3JOVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:22:27 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/5] ARM: ux500: adjust the TC3589x devices to the binding
Date: Tue, 15 Oct 2013 23:22:20 +0200
Message-Id: <1381872140-23509-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TC3589x devices appearing in the ST Ericsson device trees
are adjusted to use the new binding so this is in a good shape,
and we add the keypad on the TVK1281618 UIB so this is working
again.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi | 39 +++++++++++++++++++++++++-----
 arch/arm/boot/dts/ste-hrefprev60.dtsi      |  8 +++---
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
index 76d3ef1..4c539bb 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
@@ -15,26 +15,53 @@
 
 / {
 	soc {
-		/* Add Synaptics touch screen, TC35892 keypad etc here */
+		/* Add Synaptics touch screen, TC35893 keypad etc here */
 		i2c@80004000 {
-			tc3589x@44 {
-				compatible = "tc3589x";
+			tc35893@44 {
+				compatible = "toshiba,tc35893";
 				reg = <0x44>;
 				interrupt-parent = <&gpio6>;
 				interrupts = <26 IRQ_TYPE_EDGE_RISING>;
 
 				interrupt-controller;
-				#interrupt-cells = <2>;
+				#interrupt-cells = <1>;
 
 				tc3589x_gpio {
-					compatible = "tc3589x-gpio";
-					interrupts = <0 IRQ_TYPE_EDGE_RISING>;
+					compatible = "toshiba,tc3589x-gpio";
+					interrupts = <0>;
 
 					interrupt-controller;
 					#interrupt-cells = <2>;
 					gpio-controller;
 					#gpio-cells = <2>;
 				};
+				tc3589x_keypad {
+					compatible = "toshiba,tc3589x-keypad";
+					interrupts = <6>;
+					debounce-delay-ms = <4>;
+					keypad,num-columns = /bits/ 8 <8>;
+					keypad,num-rows = /bits/ 8 <8>;
+					linux,no-autorepeat;
+					linux,wakeup;
+					linux,keymap = <0x0301006b
+						        0x04010066
+							0x06040072
+							0x040200d7
+							0x0303006a
+							0x0205000e
+							0x0607008b
+							0x0500001c
+							0x0403000b
+							0x03040034
+							0x05020067
+							0x0305006c
+							0x040500e7
+							0x0005009e
+							0x06020073
+							0x01030039
+							0x07060069
+							0x050500d9>;
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/ste-hrefprev60.dtsi b/arch/arm/boot/dts/ste-hrefprev60.dtsi
index b2cd7bc..6b271a4 100644
--- a/arch/arm/boot/dts/ste-hrefprev60.dtsi
+++ b/arch/arm/boot/dts/ste-hrefprev60.dtsi
@@ -28,18 +28,18 @@
 				reg = <0x33>;
 			};
 
-			tc3589x@42 {
-				compatible = "tc3589x";
+			tc35892@42 {
+				compatible = "toshiba,tc35892";
 				reg = <0x42>;
 				interrupt-parent = <&gpio6>;
 				interrupts = <25 IRQ_TYPE_EDGE_RISING>;
 
 				interrupt-controller;
-				#interrupt-cells = <2>;
+				#interrupt-cells = <1>;
 
 				tc3589x_gpio: tc3589x_gpio {
 					compatible = "tc3589x-gpio";
-					interrupts = <0 IRQ_TYPE_EDGE_RISING>;
+					interrupts = <0>;
 
 					interrupt-controller;
 					#interrupt-cells = <2>;
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3KLOQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:16:38 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36193 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3KLOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:16:35 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/5 v2] ARM: ux500: adjust the TC3589x devices to the binding
Date: Tue, 12 Nov 2013 15:16:25 +0100
Message-Id: <1384265785-11165-1-git-send-email-linus.walleij@linaro.org>
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
ChangeLog v1->v2:
- Adjust DT to match the u32 rows/columns binding.
---
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi | 39 +++++++++++++++++++++++++-----
 arch/arm/boot/dts/ste-hrefprev60.dtsi      |  8 +++---
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
index 76d3ef13175f..61b180ea92ca 100644
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
+					keypad,num-columns = <8>;
+					keypad,num-rows = <8>;
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
index b2cd7bc2752f..6b271a410d03 100644
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


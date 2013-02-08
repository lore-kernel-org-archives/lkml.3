Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab3BHIDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:03:01 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56633 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3BHIDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:03:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linuxppc-dev@list.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 1/2] powerpc/5200: Add Lite5200 on-board LEDs as devices
Date: Fri,  8 Feb 2013 08:02:50 +0000
Message-Id: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lite5200 evaluation board has a number of debug LEDs that Linux
doesn't know about yet. This change adds a gpio-leds stanza to the
lite5200 device tree so that the correct driver can get hooked up.

Also, make use of the dtc labels feature to reduce the number of source
lines required to add the gpio-controller property to the general
purpose timer nodes. In addition, the required #gpio-cells properties
are added to the common mpc5200b dtsi include file so that each board
doesn't need to add them explicitly. This still doesn't enable gpio
mode, 'gpio-controller' is required for that, but it means less work
needs to be done by board ports.

Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/boot/dts/lite5200b.dts |   23 +++++++++++++++++++----
 arch/powerpc/boot/dts/mpc5200b.dtsi |   25 +++++++++++++++++--------
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index fb288bb..5abb46c 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -12,19 +12,34 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+&gpt2 { gpio-controller; };
+&gpt3 { gpio-controller; };
+
 / {
 	model = "fsl,lite5200b";
 	compatible = "fsl,lite5200b";
 
+	leds {
+		compatible = "gpio-leds";
+		tmr2 {
+			gpios = <&gpt2 0 1>;
+		};
+		tmr3 {
+			gpios = <&gpt3 0 1>;
+			linux,default-trigger = "heartbeat";
+		};
+		led1 { gpios = <&gpio_wkup 2 1>; };
+		led2 { gpios = <&gpio_simple 3 1>; };
+		led3 { gpios = <&gpio_wkup 3 1>; };
+		led4 { gpios = <&gpio_simple 2 1>; };
+	};
+
 	memory {
 		reg = <0x00000000 0x10000000>;	// 256MB
 	};
 
 	soc5200@f0000000 {
-		timer@600 {	// General Purpose Timer
-			fsl,has-wdt;
-		};
-
 		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <0>;
diff --git a/arch/powerpc/boot/dts/mpc5200b.dtsi b/arch/powerpc/boot/dts/mpc5200b.dtsi
index 39ed65a..969b220 100644
--- a/arch/powerpc/boot/dts/mpc5200b.dtsi
+++ b/arch/powerpc/boot/dts/mpc5200b.dtsi
@@ -64,50 +64,59 @@
 			reg = <0x500 0x80>;
 		};
 
-		timer@600 {	// General Purpose Timer
+		gpt0: timer@600 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x600 0x10>;
 			interrupts = <1 9 0>;
+			// add 'fsl,has-wdt' to enable watchdog
 		};
 
-		timer@610 {	// General Purpose Timer
+		gpt1: timer@610 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x610 0x10>;
 			interrupts = <1 10 0>;
 		};
 
-		timer@620 {	// General Purpose Timer
+		gpt2: timer@620 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x620 0x10>;
 			interrupts = <1 11 0>;
 		};
 
-		timer@630 {	// General Purpose Timer
+		gpt3: timer@630 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x630 0x10>;
 			interrupts = <1 12 0>;
 		};
 
-		timer@640 {	// General Purpose Timer
+		gpt4: timer@640 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x640 0x10>;
 			interrupts = <1 13 0>;
 		};
 
-		timer@650 {	// General Purpose Timer
+		gpt5: timer@650 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x650 0x10>;
 			interrupts = <1 14 0>;
 		};
 
-		timer@660 {	// General Purpose Timer
+		gpt6: timer@660 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x660 0x10>;
 			interrupts = <1 15 0>;
 		};
 
-		timer@670 {	// General Purpose Timer
+		gpt7: timer@670 {	// General Purpose Timer
 			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
+			#gpio-cells = <2>;  // Add 'gpio-controller;' to enable gpio mode
 			reg = <0x670 0x10>;
 			interrupts = <1 16 0>;
 		};
-- 
1.7.10.4


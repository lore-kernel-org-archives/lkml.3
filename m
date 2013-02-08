Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3BHIDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:03:06 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60724 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987Ab3BHIDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:03:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linuxppc-dev@list.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 2/2] powerpc/5200: Use the gpt* labels to simplify mpc5200 dts files
Date: Fri,  8 Feb 2013 08:02:51 +0000
Message-Id: <1360310571-31494-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
References: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DTC labels feature allows a dts file to reference a node without
having to reproduce the entire node hierarchy above it. We can use this
to simplify the MPC5200 board dts files by referencing the gpt nodes by
label.

Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/boot/dts/a3m071.dts    |    6 ++--
 arch/powerpc/boot/dts/a4m072.dts    |   27 ++++--------------
 arch/powerpc/boot/dts/cm5200.dts    |    6 ++--
 arch/powerpc/boot/dts/digsy_mtc.dts |   14 ++--------
 arch/powerpc/boot/dts/media5200.dts |    6 ++--
 arch/powerpc/boot/dts/motionpro.dts |   26 ++++++++----------
 arch/powerpc/boot/dts/mucmc52.dts   |   48 ++++++++------------------------
 arch/powerpc/boot/dts/o2d.dtsi      |   25 +++++------------
 arch/powerpc/boot/dts/pcm030.dts    |   48 ++++++--------------------------
 arch/powerpc/boot/dts/pcm032.dts    |   45 ++++++------------------------
 arch/powerpc/boot/dts/uc101.dts     |   52 ++++++-----------------------------
 11 files changed, 69 insertions(+), 234 deletions(-)

diff --git a/arch/powerpc/boot/dts/a3m071.dts b/arch/powerpc/boot/dts/a3m071.dts
index 877a28c..bf81b8f 100644
--- a/arch/powerpc/boot/dts/a3m071.dts
+++ b/arch/powerpc/boot/dts/a3m071.dts
@@ -17,6 +17,8 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+
 / {
 	model = "anonymous,a3m071";
 	compatible = "anonymous,a3m071";
@@ -30,10 +32,6 @@
 		bus-frequency = <0>; /* From boot loader */
 		system-frequency = <0>; /* From boot loader */
 
-		timer@600 {
-			fsl,has-wdt;
-		};
-
 		spi@f00 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/a4m072.dts b/arch/powerpc/boot/dts/a4m072.dts
index fabe7b7..1f02034 100644
--- a/arch/powerpc/boot/dts/a4m072.dts
+++ b/arch/powerpc/boot/dts/a4m072.dts
@@ -15,6 +15,11 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+&gpt3 { gpio-controller; };
+&gpt4 { gpio-controller; };
+&gpt5 { gpio-controller; };
+
 / {
 	model = "anonymous,a4m072";
 	compatible = "anonymous,a4m072";
@@ -34,28 +39,6 @@
 			fsl,init-fd-counters = <0x3333>;
 		};
 
-		timer@600 {
-			fsl,has-wdt;
-		};
-
-		gpt3: timer@630 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt4: timer@640 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt5: timer@650 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		spi@f00 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
index ad3a4f4..fb580dd 100644
--- a/arch/powerpc/boot/dts/cm5200.dts
+++ b/arch/powerpc/boot/dts/cm5200.dts
@@ -12,15 +12,13 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+
 / {
 	model = "schindler,cm5200";
 	compatible = "schindler,cm5200";
 
 	soc5200@f0000000 {
-		timer@600 {	// General Purpose Timer
-			fsl,has-wdt;
-		};
-
 		can@900 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index a7511f2..955bff6 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -13,6 +13,9 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { gpio-controller; fsl,has-wdt; };
+&gpt1 { gpio-controller; };
+
 / {
 	model = "intercontrol,digsy-mtc";
 	compatible = "intercontrol,digsy-mtc";
@@ -22,17 +25,6 @@
 	};
 
 	soc5200@f0000000 {
-		timer@600 {	// General Purpose Timer
-			#gpio-cells = <2>;
-			fsl,has-wdt;
-			gpio-controller;
-		};
-
-		timer@610 {
-			#gpio-cells = <2>;
-			gpio-controller;
-		};
-
 		rtc@800 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index 48d72f3..b5413cb 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -13,6 +13,8 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+
 / {
 	model = "fsl,media5200";
 	compatible = "fsl,media5200";
@@ -41,10 +43,6 @@
 	soc5200@f0000000 {
 		bus-frequency = <132000000>;// 132 MHz
 
-		timer@600 {	// General Purpose Timer
-			fsl,has-wdt;
-		};
-
 		psc@2000 {	// PSC1
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
index 0b78e89..bbabd97 100644
--- a/arch/powerpc/boot/dts/motionpro.dts
+++ b/arch/powerpc/boot/dts/motionpro.dts
@@ -12,26 +12,22 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+&gpt6 { // Motion-PRO status LED
+	compatible = "promess,motionpro-led";
+	label = "motionpro-statusled";
+	blink-delay = <100>; // 100 msec
+};
+&gpt7 { // Motion-PRO ready LED
+	compatible = "promess,motionpro-led";
+	label = "motionpro-readyled";
+};
+
 / {
 	model = "promess,motionpro";
 	compatible = "promess,motionpro";
 
 	soc5200@f0000000 {
-		timer@600 {	// General Purpose Timer
-			fsl,has-wdt;
-		};
-
-		timer@660 {	// Motion-PRO status LED
-			compatible = "promess,motionpro-led";
-			label = "motionpro-statusled";
-			blink-delay = <100>; // 100 msec
-		};
-
-		timer@670 {	// Motion-PRO ready LED
-			compatible = "promess,motionpro-led";
-			label = "motionpro-readyled";
-		};
-
 		can@900 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/mucmc52.dts b/arch/powerpc/boot/dts/mucmc52.dts
index 21d3472..d3a792b 100644
--- a/arch/powerpc/boot/dts/mucmc52.dts
+++ b/arch/powerpc/boot/dts/mucmc52.dts
@@ -13,47 +13,23 @@
 
 /include/ "mpc5200b.dtsi"
 
+/* Timer pins that need to be in GPIO mode */
+&gpt0 { gpio-controller; };
+&gpt1 { gpio-controller; };
+&gpt2 { gpio-controller; };
+&gpt3 { gpio-controller; };
+
+/* Disabled timers */
+&gpt4 { status = "disabled"; };
+&gpt5 { status = "disabled"; };
+&gpt6 { status = "disabled"; };
+&gpt7 { status = "disabled"; };
+
 / {
 	model = "manroland,mucmc52";
 	compatible = "manroland,mucmc52";
 
 	soc5200@f0000000 {
-		gpt0: timer@600 {	// GPT 0 in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt1: timer@610 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		timer@640 {
-			status = "disabled";
-		};
-
-		timer@650 {
-			status = "disabled";
-		};
-
-		timer@660 {
-			status = "disabled";
-		};
-
-		timer@670 {
-			status = "disabled";
-		};
-
 		rtc@800 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/o2d.dtsi b/arch/powerpc/boot/dts/o2d.dtsi
index 24f6680..d26b7e3 100644
--- a/arch/powerpc/boot/dts/o2d.dtsi
+++ b/arch/powerpc/boot/dts/o2d.dtsi
@@ -12,6 +12,13 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 {
+	gpio-controller;
+	fsl,has-wdt;
+	fsl,wdt-on-boot = <0>;
+};
+&gpt1 { gpio-controller; };
+
 / {
 	model = "ifm,o2d";
 	compatible = "ifm,o2d";
@@ -22,24 +29,6 @@
 
 	soc5200@f0000000 {
 
-		gpio_simple: gpio@b00 {
-		};
-
-		timer@600 {	// General Purpose Timer
-			#gpio-cells = <2>;
-			gpio-controller;
-			fsl,has-wdt;
-			fsl,wdt-on-boot = <0>;
-		};
-
-		timer@610 {
-			#gpio-cells = <2>;
-			gpio-controller;
-		};
-
-		timer7: timer@670 {
-		};
-
 		rtc@800 {
 			status = "disabled";
 		};
diff --git a/arch/powerpc/boot/dts/pcm030.dts b/arch/powerpc/boot/dts/pcm030.dts
index 96512c0..192e66a 100644
--- a/arch/powerpc/boot/dts/pcm030.dts
+++ b/arch/powerpc/boot/dts/pcm030.dts
@@ -14,51 +14,19 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+&gpt2 { gpio-controller; };
+&gpt3 { gpio-controller; };
+&gpt4 { gpio-controller; };
+&gpt5 { gpio-controller; };
+&gpt6 { gpio-controller; };
+&gpt7 { gpio-controller; };
+
 / {
 	model = "phytec,pcm030";
 	compatible = "phytec,pcm030";
 
 	soc5200@f0000000 {
-		timer@600 {		// General Purpose Timer
-			fsl,has-wdt;
-		};
-
-		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt6: timer@660 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		audioplatform: psc@2000 { /* PSC1 in ac97 mode */
 			compatible = "mpc5200b-psc-ac97","fsl,mpc5200b-psc-ac97";
 			cell-index = <0>;
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 1dd478b..96b139b 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -14,6 +14,14 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { fsl,has-wdt; };
+&gpt2 { gpio-controller; };
+&gpt3 { gpio-controller; };
+&gpt4 { gpio-controller; };
+&gpt5 { gpio-controller; };
+&gpt6 { gpio-controller; };
+&gpt7 { gpio-controller; };
+
 / {
 	model = "phytec,pcm032";
 	compatible = "phytec,pcm032";
@@ -23,43 +31,6 @@
 	};
 
 	soc5200@f0000000 {
-		timer@600 {		// General Purpose Timer
-			fsl,has-wdt;
-		};
-
-		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt6: timer@660 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x660 0x10>;
-			interrupts = <1 15 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		psc@2000 {	/* PSC1 is ac97 */
 			compatible = "fsl,mpc5200b-psc-ac97","fsl,mpc5200-psc-ac97";
 			cell-index = <0>;
diff --git a/arch/powerpc/boot/dts/uc101.dts b/arch/powerpc/boot/dts/uc101.dts
index ba83d54..5c46219 100644
--- a/arch/powerpc/boot/dts/uc101.dts
+++ b/arch/powerpc/boot/dts/uc101.dts
@@ -13,54 +13,20 @@
 
 /include/ "mpc5200b.dtsi"
 
+&gpt0 { gpio-controller; };
+&gpt1 { gpio-controller; };
+&gpt2 { gpio-controller; };
+&gpt3 { gpio-controller; };
+&gpt4 { gpio-controller; };
+&gpt5 { gpio-controller; };
+&gpt6 { gpio-controller; };
+&gpt7 { gpio-controller; };
+
 / {
 	model = "manroland,uc101";
 	compatible = "manroland,uc101";
 
 	soc5200@f0000000 {
-		gpt0: timer@600 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt1: timer@610 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt2: timer@620 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt3: timer@630 {	// General Purpose Timer in GPIO mode
-			compatible = "fsl,mpc5200b-gpt","fsl,mpc5200-gpt";
-			reg = <0x630 0x10>;
-			interrupts = <1 12 0>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt4: timer@640 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt5: timer@650 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt6: timer@660 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
-		gpt7: timer@670 {	// General Purpose Timer in GPIO mode
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		rtc@800 {
 			status = "disabled";
 		};
-- 
1.7.10.4


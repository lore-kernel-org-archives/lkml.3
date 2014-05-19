Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaESQny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:43:54 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54231 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbaESQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:46 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] ARM: dts: berlin: convert BG2Q to DT clock nodes
Date: Mon, 19 May 2014 18:43:31 +0200
Message-Id: <1400517811-24668-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

This converts Berlin BG2Q SoC dtsi to make use of the new DT clock
nodes for Berlin SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- adapt to new single chip control node and compatible

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2q.dtsi | 54 +++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 52c7d644e492..cd3287c95f1a 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -6,6 +6,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <dt-bindings/clock/berlin2q.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
@@ -47,32 +48,12 @@
 		};
 	};
 
-	smclk: sysmgr-clock {
+	refclk: oscillator {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <25000000>;
 	};
 
-	cfgclk: config-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <100000000>;
-	};
-
-	cpuclk: cpu-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <1200000000>;
-	};
-
-	twdclk: twdclk {
-		compatible = "fixed-factor-clock";
-		#clock-cells = <0>;
-		clocks = <&cpuclk>;
-		clock-mult = <1>;
-		clock-div = <3>;
-	};
-
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -95,7 +76,7 @@
 		local-timer@ad0600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
-			clocks = <&twdclk>;
+			clocks = <&chip CLKID_TWD>;
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
@@ -189,7 +170,7 @@
 			timer0: timer@2c00 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				interrupts = <8>;
 			};
@@ -197,7 +178,7 @@
 			timer1: timer@2c14 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c14 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -205,7 +186,7 @@
 			timer2: timer@2c28 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c28 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -213,7 +194,7 @@
 			timer3: timer@2c3c {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c3c 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -221,7 +202,7 @@
 			timer4: timer@2c50 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c50 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -229,7 +210,7 @@
 			timer5: timer@2c64 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c64 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -237,7 +218,7 @@
 			timer6: timer@2c78 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c78 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -245,7 +226,7 @@
 			timer7: timer@2c8c {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c8c 0x14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -290,9 +271,12 @@
 			};
 		};
 
-		generic-regs@ea0110 {
-			compatible = "marvell,berlin-generic-regs", "syscon";
-			reg = <0xea0110 0x10>;
+		chip: chip-control@ea0000 {
+			compatible = "marvell,berlin2q-chip-ctrl";
+			#clock-cells = <1>;
+			reg = <0xea0000 0x400>, <0xdd0170 0x10>;
+			clocks = <&refclk>;
+			clock-names = "refclk";
 		};
 
 		apb@fc0000 {
@@ -308,7 +292,7 @@
 				reg = <0x9000 0x100>;
 				interrupt-parent = <&sic>;
 				interrupts = <8>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				reg-shift = <2>;
 				status = "disabled";
 			};
@@ -318,7 +302,7 @@
 				reg = <0xa000 0x100>;
 				interrupt-parent = <&sic>;
 				interrupts = <9>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				reg-shift = <2>;
 				status = "disabled";
 			};
-- 
1.9.1


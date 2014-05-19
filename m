Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaESQnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:43:55 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42425 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbaESQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:46 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/10] ARM: dts: berlin: convert BG2 to DT clock nodes
Date: Mon, 19 May 2014 18:43:30 +0200
Message-Id: <1400517811-24668-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts Berlin BG2 SoC dtsi to make use of the new DT clock
nodes for Berlin SoCs. While at it, also fix up twdclk which is
running at cpuclk/3 instead of sysclk.

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
 arch/arm/boot/dts/berlin2.dtsi | 56 +++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 57cadd31f4e1..591d4b8c1c2b 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -12,6 +12,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/berlin2.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 / {
@@ -37,24 +38,10 @@
 		};
 	};
 
-	clocks {
-		smclk: sysmgr-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <25000000>;
-		};
-
-		cfgclk: cfg-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <100000000>;
-		};
-
-		sysclk: system-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <400000000>;
-		};
+	refclk: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
 	};
 
 	soc {
@@ -88,7 +75,7 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&sysclk>;
+			clocks = <&chip CLKID_TWD>;
 		};
 
 		apb@e80000 {
@@ -175,7 +162,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
 				interrupts = <8>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -184,7 +171,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c14 0x14>;
 				interrupts = <9>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -193,7 +180,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c28 0x14>;
 				interrupts = <10>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -202,7 +189,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c3c 0x14>;
 				interrupts = <11>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -211,7 +198,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c50 0x14>;
 				interrupts = <12>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -220,7 +207,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c64 0x14>;
 				interrupts = <13>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -229,7 +216,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c78 0x14>;
 				interrupts = <14>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -238,7 +225,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c8c 0x14>;
 				interrupts = <15>;
-				clocks = <&cfgclk>;
+				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -253,9 +240,12 @@
 			};
 		};
 
-		generic-regs@ea0184 {
-			compatible = "marvell,berlin-generic-regs", "syscon";
-			reg = <0xea0184 0x10>;
+		chip: chip-control@ea0000 {
+			compatible = "marvell,berlin2-chip-ctrl";
+			#clock-cells = <1>;
+			reg = <0xea0000 0x400>;
+			clocks = <&refclk>;
+			clock-names = "refclk";
 		};
 
 		apb@fc0000 {
@@ -305,7 +295,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <8>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
@@ -315,7 +305,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <9>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
@@ -325,7 +315,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <10>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
-- 
1.9.1


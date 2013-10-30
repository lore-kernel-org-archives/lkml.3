Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3J3O6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:58:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49652 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3J3O6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:58:31 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <r.sricharan@ti.com>
CC: Benoit Cousson <bcousson@baylibre.com>
Subject: [PATCH V2 4/7] ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar inputs
Date: Wed, 30 Oct 2013 20:27:17 +0530
Message-ID: <1383145040-15852-5-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with the crossbar IP in picture, the peripherals do not have the
fixed interrupt lines. Instead they rely on the crossbar irqchip to
allocate and map a free interrupt line to its crossbar input. So replacing
all the peripheral interrupt numbers with its fixed crossbar input lines.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   93 +++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 008396f..afb89f1 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -136,10 +136,10 @@
 		sdma: dma-controller@4a056000 {
 			compatible = "ti,omap4430-sdma";
 			reg = <0x4a056000 0x1000>;
-			interrupts = <0 12 0x4>,
-				     <0 13 0x4>,
-				     <0 14 0x4>,
-				     <0 15 0x4>;
+			interrupts = <0 7 0x4>,
+				     <0 8 0x4>,
+				     <0 9 0x4>,
+				     <0 10 0x4>;
 			#dma-cells = <1>;
 			#dma-channels = <32>;
 			#dma-requests = <127>;
@@ -150,7 +150,7 @@
 		gpio1: gpio@4ae10000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4ae10000 0x200>;
-			interrupts = <0 29 0x4>;
+			interrupts = <0 24 0x4>;
 			ti,hwmods = "gpio1";
 			clocks = <&wkupaon_iclk_mux>, <&gpio1_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -163,7 +163,7 @@
 		gpio2: gpio@48055000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48055000 0x200>;
-			interrupts = <0 30 0x4>;
+			interrupts = <0 25 0x4>;
 			ti,hwmods = "gpio2";
 			clocks = <&l3_iclk_div>, <&gpio2_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -176,7 +176,7 @@
 		gpio3: gpio@48057000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48057000 0x200>;
-			interrupts = <0 31 0x4>;
+			interrupts = <0 26 0x4>;
 			ti,hwmods = "gpio3";
 			clocks = <&l3_iclk_div>, <&gpio3_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -189,7 +189,7 @@
 		gpio4: gpio@48059000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48059000 0x200>;
-			interrupts = <0 32 0x4>;
+			interrupts = <0 27 0x4>;
 			ti,hwmods = "gpio4";
 			clocks = <&l3_iclk_div>, <&gpio4_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -202,7 +202,7 @@
 		gpio5: gpio@4805b000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805b000 0x200>;
-			interrupts = <0 33 0x4>;
+			interrupts = <0 28 0x4>;
 			ti,hwmods = "gpio5";
 			clocks = <&l3_iclk_div>, <&gpio5_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -215,7 +215,7 @@
 		gpio6: gpio@4805d000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805d000 0x200>;
-			interrupts = <0 34 0x4>;
+			interrupts = <0 29 0x4>;
 			ti,hwmods = "gpio6";
 			clocks = <&l3_iclk_div>, <&gpio6_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -228,7 +228,7 @@
 		gpio7: gpio@48051000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48051000 0x200>;
-			interrupts = <0 35 0x4>;
+			interrupts = <0 30 0x4>;
 			ti,hwmods = "gpio7";
 			clocks = <&l3_iclk_div>, <&gpio7_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -241,7 +241,7 @@
 		gpio8: gpio@48053000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48053000 0x200>;
-			interrupts = <0 121 0x4>;
+			interrupts = <0 116 0x4>;
 			ti,hwmods = "gpio8";
 			clocks = <&l3_iclk_div>, <&gpio8_dbclk>;
 			clock-names = "fck", "dbclk";
@@ -254,7 +254,7 @@
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-			interrupts = <0 72 0x4>;
+			interrupts = <0 67 0x4>;
 			ti,hwmods = "uart1";
 			clocks = <&uart1_gfclk_mux>;
 			clock-names = "fck";
@@ -265,7 +265,7 @@
 		uart2: serial@4806c000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806c000 0x100>;
-			interrupts = <0 73 0x4>;
+			interrupts = <0 68 0x4>;
 			ti,hwmods = "uart2";
 			clocks = <&uart2_gfclk_mux>;
 			clock-names = "fck";
@@ -276,7 +276,7 @@
 		uart3: serial@48020000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48020000 0x100>;
-			interrupts = <0 74 0x4>;
+			interrupts = <0 69 0x4>;
 			ti,hwmods = "uart3";
 			clocks = <&uart3_gfclk_mux>;
 			clock-names = "fck";
@@ -287,7 +287,7 @@
 		uart4: serial@4806e000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806e000 0x100>;
-			interrupts = <0 70 0x4>;
+			interrupts = <0 65 0x4>;
 			ti,hwmods = "uart4";
 			clocks = <&uart4_gfclk_mux>;
 			clock-names = "fck";
@@ -298,7 +298,7 @@
 		uart5: serial@48066000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48066000 0x100>;
-			interrupts = <0 105 0x4>;
+			interrupts = <0 100 0x4>;
 			ti,hwmods = "uart5";
 			clocks = <&uart5_gfclk_mux>;
 			clock-names = "fck";
@@ -309,7 +309,7 @@
 		uart6: serial@48068000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48068000 0x100>;
-			interrupts = <0 106 0x4>;
+			interrupts = <0 101 0x4>;
 			ti,hwmods = "uart6";
 			clocks = <&uart6_gfclk_mux>;
 			clock-names = "fck";
@@ -352,7 +352,7 @@
 		timer1: timer@4ae18000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4ae18000 0x80>;
-			interrupts = <0 37 0x4>;
+			interrupts = <0 32 0x4>;
 			ti,hwmods = "timer1";
 			clocks = <&timer1_gfclk_mux>;
 			clock-names = "fck";
@@ -362,7 +362,7 @@
 		timer2: timer@48032000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48032000 0x80>;
-			interrupts = <0 38 0x4>;
+			interrupts = <0 33 0x4>;
 			ti,hwmods = "timer2";
 			clocks = <&timer2_gfclk_mux>;
 			clock-names = "fck";
@@ -371,7 +371,7 @@
 		timer3: timer@48034000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48034000 0x80>;
-			interrupts = <0 39 0x4>;
+			interrupts = <0 34 0x4>;
 			ti,hwmods = "timer3";
 			clocks = <&timer3_gfclk_mux>;
 			clock-names = "fck";
@@ -380,7 +380,7 @@
 		timer4: timer@48036000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48036000 0x80>;
-			interrupts = <0 40 0x4>;
+			interrupts = <0 35 0x4>;
 			ti,hwmods = "timer4";
 			clocks = <&timer4_gfclk_mux>;
 			clock-names = "fck";
@@ -389,7 +389,7 @@
 		timer5: timer@48820000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48820000 0x80>;
-			interrupts = <0 41 0x4>;
+			interrupts = <0 36 0x4>;
 			ti,hwmods = "timer5";
 			clocks = <&timer5_gfclk_mux>;
 			clock-names = "fck";
@@ -399,7 +399,7 @@
 		timer6: timer@48822000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48822000 0x80>;
-			interrupts = <0 42 0x4>;
+			interrupts = <0 37 0x4>;
 			ti,hwmods = "timer6";
 			clocks = <&timer6_gfclk_mux>;
 			clock-names = "fck";
@@ -410,7 +410,7 @@
 		timer7: timer@48824000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48824000 0x80>;
-			interrupts = <0 43 0x4>;
+			interrupts = <0 38 0x4>;
 			ti,hwmods = "timer7";
 			clocks = <&timer7_gfclk_mux>;
 			clock-names = "fck";
@@ -420,7 +420,7 @@
 		timer8: timer@48826000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48826000 0x80>;
-			interrupts = <0 44 0x4>;
+			interrupts = <0 39 0x4>;
 			ti,hwmods = "timer8";
 			clocks = <&timer8_gfclk_mux>;
 			clock-names = "fck";
@@ -431,7 +431,7 @@
 		timer9: timer@4803e000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4803e000 0x80>;
-			interrupts = <0 45 0x4>;
+			interrupts = <0 40 0x4>;
 			ti,hwmods = "timer9";
 			clocks = <&timer9_gfclk_mux>;
 			clock-names = "fck";
@@ -440,7 +440,7 @@
 		timer10: timer@48086000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48086000 0x80>;
-			interrupts = <0 46 0x4>;
+			interrupts = <0 41 0x4>;
 			ti,hwmods = "timer10";
 			clocks = <&timer10_gfclk_mux>;
 			clock-names = "fck";
@@ -449,7 +449,7 @@
 		timer11: timer@48088000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48088000 0x80>;
-			interrupts = <0 47 0x4>;
+			interrupts = <0 42 0x4>;
 			ti,hwmods = "timer11";
 			clocks = <&timer11_gfclk_mux>;
 			clock-names = "fck";
@@ -487,16 +487,23 @@
 		wdt2: wdt@4ae14000 {
 			compatible = "ti,omap4-wdt";
 			reg = <0x4ae14000 0x80>;
-			interrupts = <0 80 0x4>;
+			interrupts = <0 75 0x4>;
 			ti,hwmods = "wd_timer2";
 			clocks = <&sys_32k_ck>;
 			clock-names = "fck";
 		};
 
+		dmm: dmm@4e000000 {
+			compatible = "ti,omap5-dmm";
+			reg = <0x4e000000 0x800>;
+			interrupts = <0 108 0x4>;
+			ti,hwmods = "dmm";
+		};
+
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48070000 0x100>;
-			interrupts = <0 56 0x4>;
+			interrupts = <0 51 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c1";
@@ -508,7 +515,7 @@
 		i2c2: i2c@48072000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48072000 0x100>;
-			interrupts = <0 57 0x4>;
+			interrupts = <0 52 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c2";
@@ -520,7 +527,7 @@
 		i2c3: i2c@48060000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48060000 0x100>;
-			interrupts = <0 61 0x4>;
+			interrupts = <0 56 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c3";
@@ -532,7 +539,7 @@
 		i2c4: i2c@4807a000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807a000 0x100>;
-			interrupts = <0 62 0x4>;
+			interrupts = <0 57 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c4";
@@ -544,7 +551,7 @@
 		i2c5: i2c@4807c000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807c000 0x100>;
-			interrupts = <0 60 0x4>;
+			interrupts = <0 55 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c5";
@@ -556,7 +563,7 @@
 		mmc1: mmc@4809c000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x4809c000 0x400>;
-			interrupts = <0 83 0x4>;
+			interrupts = <0 78 0x4>;
 			ti,hwmods = "mmc1";
 			clocks = <&mmc1_fclk_div>, <&mmc1_clk32k>;
 			clock-names = "fck", "clk32k";
@@ -570,7 +577,7 @@
 		mmc2: mmc@480b4000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480b4000 0x400>;
-			interrupts = <0 86 0x4>;
+			interrupts = <0 81 0x4>;
 			ti,hwmods = "mmc2";
 			clocks = <&mmc2_fclk_div>, <&mmc2_clk32k>;
 			clock-names = "fck", "clk32k";
@@ -583,7 +590,7 @@
 		mmc3: mmc@480ad000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480ad000 0x400>;
-			interrupts = <0 94 0x4>;
+			interrupts = <0 89 0x4>;
 			ti,hwmods = "mmc3";
 			clocks = <&mmc3_gfclk_div>, <&mmc3_clk32k>;
 			clock-names = "fck", "clk32k";
@@ -596,7 +603,7 @@
 		mmc4: mmc@480d1000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480d1000 0x400>;
-			interrupts = <0 96 0x4>;
+			interrupts = <0 91 0x4>;
 			ti,hwmods = "mmc4";
 			clocks = <&mmc4_gfclk_div>, <&mmc4_clk32k>;
 			clock-names = "fck", "clk32k";
@@ -609,7 +616,7 @@
 		mcspi1: spi@48098000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x48098000 0x200>;
-			interrupts = <0 65 0x4>;
+			interrupts = <0 60 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi1";
@@ -632,7 +639,7 @@
 		mcspi2: spi@4809a000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x4809a000 0x200>;
-			interrupts = <0 66 0x4>;
+			interrupts = <0 61 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi2";
@@ -650,7 +657,7 @@
 		mcspi3: spi@480b8000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480b8000 0x200>;
-			interrupts = <0 91 0x4>;
+			interrupts = <0 86 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi3";
@@ -665,7 +672,7 @@
 		mcspi4: spi@480ba000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480ba000 0x200>;
-			interrupts = <0 48 0x4>;
+			interrupts = <0 43 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi4";
-- 
1.7.9.5


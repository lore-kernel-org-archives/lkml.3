Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaILNPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:15:34 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:48384 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaILNP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:15:29 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org
Subject: [PATCH 4/4] ARM: shmobile: r8a7740 dtsi: Add missing INTCA clock for irqpin module
Date: Fri, 12 Sep 2014 15:15:20 +0200
Message-Id: <1410527720-18061-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clock drives the INTCA irqpin controller modules.
Before, it was assumed enabled by the bootloader or reset state.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/r8a7740.dtsi            | 14 ++++++++++----
 include/dt-bindings/clock/r8a7740-clock.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index d46c213a17ad..502483f4dccb 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -71,6 +71,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 	};
 
 	/* irqpin1: IRQ8 - IRQ15 */
@@ -91,6 +92,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 	};
 
 	/* irqpin2: IRQ16 - IRQ23 */
@@ -111,6 +113,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 	};
 
 	/* irqpin3: IRQ24 - IRQ31 */
@@ -131,6 +134,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 	};
 
 	ether: ethernet@e9a00000 {
@@ -448,8 +452,8 @@
 		mstp2_clks: mstp2_clks@e6150138 {
 			compatible = "renesas,r8a7740-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0xe6150138 4>, <0xe6150040 4>;
-			clocks = <&sub_clk>, <&sub_clk>,
-				 <&cpg_clocks R8A7740_CLK_HP>,
+			clocks = <&sub_clk>, <&cpg_clocks R8A7740_CLK_HP>,
+				 <&sub_clk>, <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>,
@@ -458,7 +462,8 @@
 				 <&sub_clk>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
-				R8A7740_CLK_SCIFA6 R8A7740_CLK_SCIFA7
+				R8A7740_CLK_SCIFA6 R8A7740_CLK_INTCA
+				R8A7740_CLK_SCIFA7
 				R8A7740_CLK_DMAC1 R8A7740_CLK_DMAC2
 				R8A7740_CLK_DMAC3 R8A7740_CLK_USBDMAC
 				R8A7740_CLK_SCIFA5 R8A7740_CLK_SCIFB
@@ -467,7 +472,8 @@
 				R8A7740_CLK_SCIFA4
 			>;
 			clock-output-names =
-				"scifa6", "scifa7", "dmac1", "dmac2", "dmac3",
+				"scifa6", "intca",
+				"scifa7", "dmac1", "dmac2", "dmac3",
 				"usbdmac", "scifa5", "scifb", "scifa0", "scifa1",
 				"scifa2", "scifa3", "scifa4";
 		};
diff --git a/include/dt-bindings/clock/r8a7740-clock.h b/include/dt-bindings/clock/r8a7740-clock.h
index f6b4b0fe7a43..476135da0f23 100644
--- a/include/dt-bindings/clock/r8a7740-clock.h
+++ b/include/dt-bindings/clock/r8a7740-clock.h
@@ -40,6 +40,7 @@
 
 /* MSTP2 */
 #define R8A7740_CLK_SCIFA6	30
+#define R8A7740_CLK_INTCA	29
 #define R8A7740_CLK_SCIFA7	22
 #define R8A7740_CLK_DMAC1	18
 #define R8A7740_CLK_DMAC2	17
-- 
1.9.1


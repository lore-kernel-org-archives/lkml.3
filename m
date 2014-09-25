Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaIYQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:29:28 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51794 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaIYQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:55 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 10/13] ARM: shmobile: r8a7740 dtsi: Add PM domain support
Date: Thu, 25 Sep 2014 18:28:37 +0200
Message-Id: <1411662520-22795-11-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a device node for the System Controller, with subnodes that
represent the hardware power area hierarchy.
Hook up all devices to their respective PM domains.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "[PATCH] ARM: hw_breakpoint: Trap undef instruction
exceptions on wake-up", or an alternative solution. Else resuming from
s2ram will cause a crash.
As the HDMI-Link device is not yet instantiated from DT, this does not
depend on "[PATCH/RFC] fbdev: sh_mobile_hdmi: Re-init regs before irq
re-enable on resume".

v3:
  - Move power-on/off latencies to a separate patch,
  - Add dependencies,
v2:
  - Insert power-domains property after clock-names property in the cmt1
    node.

 arch/arm/boot/dts/r8a7740.dtsi | 101 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 502483f4dccb2f45..4fead480a405bebe 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -25,6 +25,7 @@
 			device_type = "cpu";
 			reg = <0x0>;
 			clock-frequency = <800000000>;
+			power-domains = <&pd_a3sm>;
 		};
 	};
 
@@ -47,6 +48,7 @@
 		interrupts = <0 58 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_CMT1>;
 		clock-names = "fck";
+		power-domains = <&pd_c5>;
 
 		renesas,channels-mask = <0x3f>;
 
@@ -72,6 +74,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
+		power-domains = <&pd_a4s>;
 	};
 
 	/* irqpin1: IRQ8 - IRQ15 */
@@ -93,6 +96,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
+		power-domains = <&pd_a4s>;
 	};
 
 	/* irqpin2: IRQ16 - IRQ23 */
@@ -114,6 +118,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
+		power-domains = <&pd_a4s>;
 	};
 
 	/* irqpin3: IRQ24 - IRQ31 */
@@ -135,6 +140,7 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
+		power-domains = <&pd_a4s>;
 	};
 
 	ether: ethernet@e9a00000 {
@@ -143,6 +149,7 @@
 		      <0xe9a01800 0x800>;
 		interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_GETHER>;
+		power-domains = <&pd_a4s>;
 		phy-mode = "mii";
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -159,6 +166,7 @@
 			      0 203 IRQ_TYPE_LEVEL_HIGH
 			      0 204 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7740_CLK_IIC0>;
+		power-domains = <&pd_a4r>;
 		status = "disabled";
 	};
 
@@ -172,6 +180,7 @@
 			      0 72 IRQ_TYPE_LEVEL_HIGH
 			      0 73 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_IIC1>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -181,6 +190,7 @@
 		interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA0>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -190,6 +200,7 @@
 		interrupts = <0 101 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA1>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -199,6 +210,7 @@
 		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA0>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -208,6 +220,7 @@
 		interrupts = <0 103 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA3>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -217,6 +230,7 @@
 		interrupts = <0 104 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA4>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -226,6 +240,7 @@
 		interrupts = <0 105 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA5>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -235,6 +250,7 @@
 		interrupts = <0 106 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA6>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -244,6 +260,7 @@
 		interrupts = <0 107 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA7>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -253,6 +270,7 @@
 		interrupts = <0 108 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFB>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -271,12 +289,14 @@
 			<&irqpin2 4 0>, <&irqpin2 5 0>, <&irqpin2 6 0>, <&irqpin2 7 0>,
 			<&irqpin3 0 0>, <&irqpin3 1 0>, <&irqpin3 2 0>, <&irqpin3 3 0>,
 			<&irqpin3 4 0>, <&irqpin3 5 0>, <&irqpin3 6 0>, <&irqpin3 7 0>;
+			power-domains = <&pd_c5>;
 	};
 
 	tpu: pwm@e6600000 {
 		compatible = "renesas,tpu-r8a7740", "renesas,tpu";
 		reg = <0xe6600000 0x100>;
 		clocks = <&mstp3_clks R8A7740_CLK_TPU0>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 		#pwm-cells = <3>;
 	};
@@ -287,6 +307,7 @@
 		interrupts = <0 56 IRQ_TYPE_LEVEL_HIGH
 			      0 57 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_MMC>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -297,6 +318,7 @@
 			      0 118 IRQ_TYPE_LEVEL_HIGH
 			      0 119 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_SDHI0>;
+		power-domains = <&pd_a3sp>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -309,6 +331,7 @@
 			      0 122 IRQ_TYPE_LEVEL_HIGH
 			      0 123 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_SDHI1>;
+		power-domains = <&pd_a3sp>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -321,6 +344,7 @@
 			      0 126 IRQ_TYPE_LEVEL_HIGH
 			      0 127 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp4_clks R8A7740_CLK_SDHI2>;
+		power-domains = <&pd_a3sp>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -332,6 +356,7 @@
 		reg = <0xfe1f0000 0x400>;
 		interrupts = <0 9 0x4>;
 		clocks = <&mstp3_clks R8A7740_CLK_FSI>;
+		power-domains = <&pd_a4mp>;
 		status = "disabled";
 	};
 
@@ -383,6 +408,7 @@
 			compatible = "renesas,r8a7740-cpg-clocks";
 			reg = <0xe6150000 0x10000>;
 			clocks = <&extal1_clk>, <&extalr_clk>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			clock-output-names = "system", "pllc0", "pllc1",
 					     "pllc2", "r",
@@ -397,6 +423,7 @@
 			compatible = "renesas,r8a7740-div6-clock", "renesas,cpg-div6-clock";
 			reg = <0xe6150080 4>;
 			clocks = <&pllc1_div2_clk>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <0>;
 			clock-output-names = "sub";
 		};
@@ -405,6 +432,7 @@
 		pllc1_div2_clk: pllc1_div2_clk {
 			compatible = "fixed-factor-clock";
 			clocks = <&cpg_clocks R8A7740_CLK_PLLC1>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <0>;
 			clock-div = <2>;
 			clock-mult = <1>;
@@ -413,6 +441,7 @@
 		extal1_div2_clk: extal1_div2_clk {
 			compatible = "fixed-factor-clock";
 			clocks = <&extal1_clk>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <0>;
 			clock-div = <2>;
 			clock-mult = <1>;
@@ -424,6 +453,7 @@
 			compatible = "renesas,r8a7740-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0xe6150080 4>;
 			clocks = <&sub_clk>, <&sub_clk>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_SUBCK R8A7740_CLK_SUBCK2
@@ -439,6 +469,7 @@
 				 <&cpg_clocks R8A7740_CLK_B>,
 				 <&sub_clk>, <&sub_clk>,
 				 <&cpg_clocks R8A7740_CLK_B>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_CEU21 R8A7740_CLK_CEU20 R8A7740_CLK_TMU0
@@ -460,6 +491,7 @@
 				 <&sub_clk>, <&sub_clk>, <&sub_clk>,
 				 <&sub_clk>, <&sub_clk>, <&sub_clk>,
 				 <&sub_clk>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_SCIFA6 R8A7740_CLK_INTCA
@@ -489,6 +521,7 @@
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_CMT1 R8A7740_CLK_FSI R8A7740_CLK_IIC1
@@ -506,6 +539,7 @@
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>;
+			power-domains = <&pd_c5>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_USBH R8A7740_CLK_SDHI2
@@ -515,4 +549,71 @@
 				"usbhost", "sdhi2", "usbfunc", "usphy";
 		};
 	};
+
+	sysc: system-controller@e6180000 {
+		compatible = "renesas,sysc-r8a7740", "renesas,sysc-rmobile";
+		reg = <0xe6180000 8000>, <0xe6188000 8000>;
+
+		pm-domains {
+			pd_c5: c5 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#power-domain-cells = <0>;
+
+				pd_a4lc: a4lc@1 {
+					reg = <1>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4mp: a4mp@2 {
+					reg = <2>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_d4: d4@3 {
+					reg = <3>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4r: a4r@5 {
+					reg = <5>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+
+					pd_a3rv: a3rv@6 {
+						reg = <6>;
+						#power-domain-cells = <0>;
+					};
+				};
+
+				pd_a4s: a4s@10 {
+					reg = <10>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+
+					pd_a3sp: a3sp@11 {
+						reg = <11>;
+						#power-domain-cells = <0>;
+					};
+
+					pd_a3sm: a3sm@12 {
+						reg = <12>;
+						#power-domain-cells = <0>;
+					};
+
+					pd_a3sg: a3sg@13 {
+						reg = <13>;
+						#power-domain-cells = <0>;
+					};
+				};
+
+				pd_a4su: a4su@20 {
+					reg = <20>;
+					#power-domain-cells = <0>;
+				};
+			};
+		};
+	};
 };
-- 
1.9.1


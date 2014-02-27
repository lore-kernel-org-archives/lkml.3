Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaB0PtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:22 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:55421 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbaB0PtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:17 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v0 14/15] ARM: STi: DT: STiH415: 415 DT Entry for clockgen A0/1/10/11/12
Date: Thu, 27 Feb 2014 16:24:27 +0100
Message-Id: <1393514668-17440-15-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A0/1/10/11/12

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/stih415-clks.h     |  11 +
 arch/arm/boot/dts/stih415-clock.dtsi | 475 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/stih415.dtsi       |   6 +-
 3 files changed, 484 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-clks.h

diff --git a/arch/arm/boot/dts/stih415-clks.h b/arch/arm/boot/dts/stih415-clks.h
new file mode 100644
index 0000000..341c05b
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-clks.h
@@ -0,0 +1,11 @@
+/*
+ * This header provides constants clk index STMicroelectronics
+ * STiH415 SoC.
+ */
+#ifndef _CLK_STIH415
+#define _CLK_STIH415
+
+/* CLOCKGEN A0 */
+#define CLK_S_ICN_REG_0		0
+
+#endif
diff --git a/arch/arm/boot/dts/stih415-clock.dtsi b/arch/arm/boot/dts/stih415-clock.dtsi
index 174c799..24a7508 100644
--- a/arch/arm/boot/dts/stih415-clock.dtsi
+++ b/arch/arm/boot/dts/stih415-clock.dtsi
@@ -5,8 +5,15 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#include "stih415-clks.h"
+
 / {
 	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
 		/*
 		 * Fixed 30MHz oscillator input to SoC
 		 */
@@ -26,13 +33,471 @@
 		};
 
 		/*
-		 * Bootloader initialized system infrastructure clock for
-		 * serial devices.
+		 * ClockGenAs on SASG1
+		 */
+		clockgenA@fee62000 {
+			reg = <0xfee62000 0xb48>;
+
+			CLK_S_A0_PLL: CLK_S_A0_PLL {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-plls-c65";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_S_A0_PLL0_HS",
+						     "CLK_S_A0_PLL0_LS",
+						     "CLK_S_A0_PLL1";
+			};
+
+			CLK_S_A0_OSC_PREDIV: CLK_S_A0_OSC_PREDIV {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c65",
+					     "st,clkgena-prediv";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_S_A0_OSC_PREDIV";
+			};
+
+			CLK_S_A0_HS: CLK_S_A0_HS {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-hs",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_S_A0_OSC_PREDIV>,
+					 <&CLK_S_A0_PLL 0>, /* PLL0 HS */
+					 <&CLK_S_A0_PLL 2>; /* PLL1 */
+
+				clock-output-names = "CLK_S_FDMA_0",
+						     "CLK_S_FDMA_1",
+						     ""; /* CLK_S_JIT_SENSE */
+						     /* Fourth output unused */
+			};
+
+			CLK_S_A0_LS: CLK_S_A0_LS {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-ls",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_S_A0_OSC_PREDIV>,
+					 <&CLK_S_A0_PLL 1>, /* PLL0 LS */
+					 <&CLK_S_A0_PLL 2>; /* PLL1 */
+
+				clock-output-names = "CLK_S_ICN_REG_0",
+						     "CLK_S_ICN_IF_0",
+						     "CLK_S_ICN_REG_LP_0",
+						     "CLK_S_EMISS",
+						     "CLK_S_ETH1_PHY",
+						     "CLK_S_MII_REF_OUT";
+						 /* Remaining outputs unused */
+			};
+		};
+
+		clockgenA@fee81000 {
+			reg = <0xfee81000 0xb48>;
+
+			CLK_S_A1_PLL: CLK_S_A1_PLL {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-plls-c65";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_S_A1_PLL0_HS",
+						     "CLK_S_A1_PLL0_LS",
+						     "CLK_S_A1_PLL1";
+			};
+
+			CLK_S_A1_OSC_PREDIV: CLK_S_A1_OSC_PREDIV {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c65",
+					     "st,clkgena-prediv";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_S_A1_OSC_PREDIV";
+			};
+
+			CLK_S_A1_HS: CLK_S_A1_HS {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-hs",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_S_A1_OSC_PREDIV>,
+					 <&CLK_S_A1_PLL 0>, /* PLL0 HS */
+					 <&CLK_S_A1_PLL 2>; /* PLL1 */
+
+				clock-output-names = "", /* Reserved */
+						     "", /* Reserved */
+						     "CLK_S_STAC_PHY",
+						     "CLK_S_VTAC_TX_PHY";
+			};
+
+			CLK_S_A1_LS: CLK_S_A1_LS {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-ls",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_S_A1_OSC_PREDIV>,
+					 <&CLK_S_A1_PLL 1>, /* PLL0 LS */
+					 <&CLK_S_A1_PLL 2>; /* PLL1 */
+
+				clock-output-names = "CLK_S_ICN_IF_2",
+						     "CLK_S_CARD_MMC",
+						     "CLK_S_ICN_IF_1",
+						     "CLK_S_GMAC0_PHY",
+						     "CLK_S_NAND_CTRL",
+						     "", /* Reserved */
+						     "CLK_S_MII0_REF_OUT",
+						     ""; /* CLK_S_STAC_SYS */
+						 /* Remaining outputs unused */
+			};
+		};
+
+		/*
+		 * ClockGenAs on MPE41
 		 */
-		CLKS_ICN_REG_0: CLKS_ICN_REG_0 {
+		clockgenA@fde12000 {
+			reg = <0xfde12000 0xb50>;
+
+			CLK_M_A0_PLL0: CLK_M_A0_PLL0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A0_PLL0_PHI0",
+						     "CLK_M_A0_PLL0_PHI1",
+						     "CLK_M_A0_PLL0_PHI2",
+						     "CLK_M_A0_PLL0_PHI3";
+			};
+
+			CLK_M_A0_PLL1: CLK_M_A0_PLL1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A0_PLL1_PHI0",
+						     "CLK_M_A0_PLL1_PHI1",
+						     "CLK_M_A0_PLL1_PHI2",
+						     "CLK_M_A0_PLL1_PHI3";
+			};
+
+			CLK_M_A0_OSC_PREDIV: CLK_M_A0_OSC_PREDIV {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A0_OSC_PREDIV";
+			};
+
+			CLK_M_A0_DIV0: CLK_M_A0_DIV0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A0_OSC_PREDIV>,
+					 <&CLK_M_A0_PLL0 0>, /* PLL0 PHI0 */
+					 <&CLK_M_A0_PLL1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "CLK_M_APB_PM", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "CLK_M_PP_DMU_0",
+						     "CLK_M_PP_DMU_1",
+						     "CLK_M_ICM_DISP",
+						     ""; /* Unused */
+			};
+
+			CLK_M_A0_DIV1: CLK_M_A0_DIV1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A0_OSC_PREDIV>,
+					 <&CLK_M_A0_PLL0 1>, /* PLL0 PHI1 */
+					 <&CLK_M_A0_PLL1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "CLK_M_A9_EXT2F",
+						     "CLK_M_ST40RT",
+						     "CLK_M_ST231_DMU_0",
+						     "CLK_M_ST231_DMU_1",
+						     "CLK_M_ST231_AUD",
+						     "CLK_M_ST231_GP_0";
+			};
+
+			CLK_M_A0_DIV2: CLK_M_A0_DIV2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A0_OSC_PREDIV>,
+					 <&CLK_M_A0_PLL0 2>, /* PLL0 PHI2 */
+					 <&CLK_M_A0_PLL1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "CLK_M_ST231_GP_1",
+						     "CLK_M_ICN_CPU",
+						     "CLK_M_ICN_STAC",
+						     "CLK_M_ICN_DMU_0",
+						     "CLK_M_ICN_DMU_1",
+						     "", /* Unused */
+						     "", /* Unused */
+						     ""; /* Unused */
+			};
+
+			CLK_M_A0_DIV3: CLK_M_A0_DIV3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A0_OSC_PREDIV>,
+					 <&CLK_M_A0_PLL0 3>, /* PLL0 PHI3 */
+					 <&CLK_M_A0_PLL1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "CLK_M_ICN_ERAM",
+						     "CLK_M_A9_TRACE";
+			};
+		};
+
+		clockgenA@fd6db000 {
+			reg = <0xfd6db000 0xb50>;
+
+			CLK_M_A1_PLL0: CLK_M_A1_PLL0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A1_PLL0_PHI0",
+						     "CLK_M_A1_PLL0_PHI1",
+						     "CLK_M_A1_PLL0_PHI2",
+						     "CLK_M_A1_PLL0_PHI3";
+			};
+
+			CLK_M_A1_PLL1: CLK_M_A1_PLL1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A1_PLL1_PHI0",
+						     "CLK_M_A1_PLL1_PHI1",
+						     "CLK_M_A1_PLL1_PHI2",
+						     "CLK_M_A1_PLL1_PHI3";
+			};
+
+			CLK_M_A1_OSC_PREDIV: CLK_M_A1_OSC_PREDIV {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A1_OSC_PREDIV";
+			};
+
+			CLK_M_A1_DIV0: CLK_M_A1_DIV0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A1_OSC_PREDIV>,
+					 <&CLK_M_A1_PLL0 0>, /* PLL0 PHI0 */
+					 <&CLK_M_A1_PLL1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "CLK_M_FDMA_12",
+						     "CLK_M_FDMA_10",
+						     "CLK_M_FDMA_11",
+						     "CLK_M_HVA_LMI",
+						     "CLK_M_PROC_SC",
+						     "CLK_M_TP",
+						     "CLK_M_ICN_GPU",
+						     "CLK_M_ICN_VDP_0";
+			};
+
+			CLK_M_A1_DIV1: CLK_M_A1_DIV1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A1_OSC_PREDIV>,
+					 <&CLK_M_A1_PLL0 1>, /* PLL0 PHI1 */
+					 <&CLK_M_A1_PLL1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "CLK_M_ICN_VDP_1",
+						     "CLK_M_ICN_VDP_2",
+						     "CLK_M_ICN_VDP_3",
+						     "CLK_M_PRV_T1_BUS",
+						     "CLK_M_ICN_VDP_4",
+						     "CLK_M_ICN_REG_10",
+						     "", /* Unused */
+						     ""; /* CLK_M_ICN_ST231 */
+			};
+
+			CLK_M_A1_DIV2: CLK_M_A1_DIV2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A1_OSC_PREDIV>,
+					 <&CLK_M_A1_PLL0 2>, /* PLL0 PHI2 */
+					 <&CLK_M_A1_PLL1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "CLK_M_FVDP_PROC_ALT",
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     ""; /* Unused */
+			};
+
+			CLK_M_A1_DIV3: CLK_M_A1_DIV3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A1_OSC_PREDIV>,
+					 <&CLK_M_A1_PLL0 3>, /* PLL0 PHI3 */
+					 <&CLK_M_A1_PLL1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     ""; /* Unused */
+			};
+		};
+
+		CLK_M_A9_EXT2F_DIV2: CLK_M_A9_EXT2F_DIV2S {
 			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <100000000>;
+			compatible = "fixed-factor-clock";
+			clocks = <&CLK_M_A0_DIV1 2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		clockgenA@fd345000 {
+			reg = <0xfd345000 0xb50>;
+
+			CLK_M_A2_PLL0: CLK_M_A2_PLL0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A2_PLL0_PHI0",
+						     "CLK_M_A2_PLL0_PHI1",
+						     "CLK_M_A2_PLL0_PHI2",
+						     "CLK_M_A2_PLL0_PHI3";
+			};
+
+			CLK_M_A2_PLL1: CLK_M_A2_PLL1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A2_PLL1_PHI0",
+						     "CLK_M_A2_PLL1_PHI1",
+						     "CLK_M_A2_PLL1_PHI2",
+						     "CLK_M_A2_PLL1_PHI3";
+			};
+
+			CLK_M_A2_OSC_PREDIV: CLK_M_A2_OSC_PREDIV {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&CLK_SYSIN>;
+
+				clock-output-names = "CLK_M_A2_OSC_PREDIV";
+			};
+
+			CLK_M_A2_DIV0: CLK_M_A2_DIV0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A2_OSC_PREDIV>,
+					 <&CLK_M_A2_PLL0 0>, /* PLL0 PHI0 */
+					 <&CLK_M_A2_PLL1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "CLK_M_VTAC_MAIN_PHY",
+						     "CLK_M_VTAC_AUX_PHY",
+						     "CLK_M_STAC_PHY",
+						     "CLK_M_STAC_SYS",
+						     "", /* CLK_M_MPESTAC_PG */
+						     "", /* CLK_M_MPESTAC_WC */
+						     "", /* CLK_M_MPEVTACAUX_PG*/
+						     ""; /* CLK_M_MPEVTACMAIN_PG*/
+			};
+
+			CLK_M_A2_DIV1: CLK_M_A2_DIV1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A2_OSC_PREDIV>,
+					 <&CLK_M_A2_PLL0 1>, /* PLL0 PHI1 */
+					 <&CLK_M_A2_PLL1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "", /* CLK_M_MPEVTACRX0_WC */
+						     "", /* CLK_M_MPEVTACRX1_WC */
+						     "CLK_M_COMPO_MAIN",
+						     "CLK_M_COMPO_AUX",
+						     "CLK_M_BDISP_0",
+						     "CLK_M_BDISP_1",
+						     "CLK_M_ICN_BDISP_0",
+						     "CLK_M_ICN_BDISP_1";
+			};
+
+			CLK_M_A2_DIV2: CLK_M_A2_DIV2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A2_OSC_PREDIV>,
+					 <&CLK_M_A2_PLL0 2>, /* PLL0 PHI2 */
+					 <&CLK_M_A2_PLL1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "", /* CLK_M_ICN_HQVDP0 */
+						     "", /* CLK_M_ICN_HQVDP1 */
+						     "CLK_M_ICN_COMPO",
+						     "", /* CLK_M_ICN_VDPAUX */
+						     "CLK_M_ICN_TS",
+						     "CLK_M_ICN_REG_LP_10",
+						     "CLK_M_DCEPHY_IMPCTRL",
+						     ""; /* Unused */
+			};
+
+			CLK_M_A2_DIV3: CLK_M_A2_DIV3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&CLK_M_A2_OSC_PREDIV>,
+					 <&CLK_M_A2_PLL0 3>, /* PLL0 PHI3 */
+					 <&CLK_M_A2_PLL1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = ""; /* Unused */
+						/* Remaining outputs unused */
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index d9c7dd1..fcda687 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -71,7 +71,7 @@
 			interrupts	= <0 197 0>;
 			pinctrl-names 	= "default";
 			pinctrl-0 	= <&pinctrl_serial2>;
-			clocks		= <&CLKS_ICN_REG_0>;
+			clocks		= <&CLK_S_A0_LS CLK_S_ICN_REG_0>;
 		};
 
 		/* SBC comms block ASCs in SASG1 */
@@ -89,7 +89,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed40000 0x110>;
 			interrupts	= <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLKS_ICN_REG_0>;
+			clocks		= <&CLK_S_A0_LS CLK_S_ICN_REG_0>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -102,7 +102,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed41000 0x110>;
 			interrupts	= <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLKS_ICN_REG_0>;
+			clocks		= <&CLK_S_A0_LS CLK_S_ICN_REG_0>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
-- 
1.9.0


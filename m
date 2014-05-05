Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaEEPzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:55:10 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42067 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbaEEPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:55:07 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH 1/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
Date: Mon,  5 May 2014 17:53:35 +0200
Message-Id: <1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-05_02:2014-05-05,2014-05-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A0/1/10/11/12

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-clks.h     |  15 ++
 arch/arm/boot/dts/stih416-clock.dtsi | 477 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi       |  10 +-
 3 files changed, 497 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih416-clks.h

diff --git a/arch/arm/boot/dts/stih416-clks.h b/arch/arm/boot/dts/stih416-clks.h
new file mode 100644
index 0000000..552c779
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-clks.h
@@ -0,0 +1,15 @@
+/*
+ * This header provides constants clk index STMicroelectronics
+ * STiH416 SoC.
+ */
+#ifndef _CLK_STIH416
+#define _CLK_STIH416
+
+/* CLOCKGEN A0 */
+#define CLK_ICN_REG		0
+#define CLK_ETH1_PHY		4
+
+/* CLOCKGEN A1 */
+#define CLK_GMAC0_PHY		3
+
+#endif
diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index a6942c7..66693e4 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -6,8 +6,15 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#include "stih416-clks.h"
+
 / {
 	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
 		/*
 		 * Fixed 30MHz oscillator inputs to SoC
 		 */
@@ -51,5 +58,475 @@
 			clock-frequency = <25000000>;
 			clock-output-names = "CLK_S_ETH1_PHY";
 		};
+
+		/*
+		 * ClockGenAs on SASG2
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
+						     /* Remaining outputs unused */
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
+						     "CLK_S_CARD_MMC_0",
+						     "CLK_S_ICN_IF_1",
+						     "CLK_S_GMAC0_PHY",
+						     "CLK_S_NAND_CTRL",
+						     "", /* Reserved */
+						     "CLK_S_MII0_REF_OUT",
+						     "CLK_S_STAC_SYS",
+						     "CLK_S_CARD_MMC_1";
+						     /* Remaining outputs unused */
+			};
+		};
+
+		/*
+		 * ClockGenAs on MPE42
+		 */
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
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "CLK_M_FDMA_12",
+						     "", /* Unused */
+						     "CLK_M_PP_DMU_0",
+						     "CLK_M_PP_DMU_1",
+						     "CLK_M_ICM_LMI",
+						     "CLK_M_VID_DMU_0";
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
+				clock-output-names = "CLK_M_VID_DMU_1",
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
+						     "CLK_M_TX_ICN_DMU_0",
+						     "CLK_M_TX_ICN_DMU_1",
+						     "CLK_M_TX_ICN_TS",
+						     "CLK_M_ICN_VDP_0",
+						     "CLK_M_ICN_VDP_1";
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
+						     "CLK_M_ICN_VP8",
+						     "", /* Unused */
+						     "CLK_M_ICN_REG_11",
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
+				clock-output-names = "", /* Unused */
+						     "CLK_M_FDMA_10",
+						     "CLK_M_FDMA_11",
+						     "CLK_M_HVA_ALT",
+						     "CLK_M_PROC_SC",
+						     "CLK_M_TP",
+						     "CLK_M_RX_ICN_DMU_0",
+						     "CLK_M_RX_ICN_DMU_1";
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
+				clock-output-names = "CLK_M_RX_ICN_TS",
+						     "CLK_M_RX_ICN_VDP_0",
+						     "", /* Unused */
+						     "CLK_M_PRV_T1_BUS",
+						     "CLK_M_ICN_REG_12",
+						     "CLK_M_ICN_REG_10",
+						     "", /* Unused */
+						     "CLK_M_ICN_ST231";
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
+						     "CLK_M_ICN_REG_13",
+						     "CLK_M_TX_ICN_GPU",
+						     "CLK_M_RX_ICN_GPU",
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* CLK_M_APB_PM_12 */
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
+						     ""; /* CLK_M_GPU_ALT */
+			};
+		};
+
+		CLK_M_A9_EXT2F_DIV2: CLK_M_A9_EXT2F_DIV2S {
+			#clock-cells = <0>;
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
+						     "CLK_M_ICN_BDISP",
+						     "CLK_M_ICN_COMPO";
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
+				clock-output-names = "CLK_M_ICN_VDP_2",
+						     "", /* Unused */
+						     "CLK_M_ICN_REG_14",
+						     "CLK_M_MDTP",
+						     "CLK_M_JPEGDEC",
+						     "", /* Unused */
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
+				clock-output-names = "", /* Unused */
+						     ""; /* CLK_M_APB_PM_11 */
+						     /* Remaining outputs unused */
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 78746d2..f5e888e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -89,7 +89,7 @@
 			status 		= "disabled";
 			reg		= <0xfed32000 0x2c>;
 			interrupts	= <0 197 0>;
-			clocks          = <&CLK_S_ICN_REG_0>;
+			clocks 		= <&CLK_S_A0_LS CLK_ICN_REG>;
 			pinctrl-names 	= "default";
 			pinctrl-0 	= <&pinctrl_serial2 &pinctrl_serial2_oe>;
 		};
@@ -109,7 +109,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed40000 0x110>;
 			interrupts	= <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_S_ICN_REG_0>;
+			clocks 		= <&CLK_S_A0_LS CLK_ICN_REG>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -122,7 +122,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed41000 0x110>;
 			interrupts	= <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_S_ICN_REG_0>;
+			clocks 		= <&CLK_S_A0_LS CLK_ICN_REG>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -176,7 +176,7 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii0>;
 			clock-names	= "stmmaceth";
-			clocks		= <&CLK_S_GMAC0_PHY>;
+			clocks		= <&CLK_S_A1_LS CLK_GMAC0_PHY>;
 		};
 
 		ethernet1: dwmac@fef08000 {
@@ -198,7 +198,7 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii1>;
 			clock-names	= "stmmaceth";
-			clocks		= <&CLK_S_ETH1_PHY>;
+			clocks		= <&CLK_S_A0_LS CLK_ETH1_PHY>;
 		};
 
 		rc: rc@fe518000 {
-- 
1.9.1


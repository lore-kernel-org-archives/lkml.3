Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaETN16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:27:58 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51548 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbaETNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:05 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v3 02/11] ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
Date: Tue, 20 May 2014 15:22:46 +0200
Message-Id: <1400592175-13176-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A0/1/10/11/12

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-clock.dtsi     | 475 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi           |  10 +-
 include/dt-bindings/clock/stih416-clks.h |  15 +
 3 files changed, 495 insertions(+), 5 deletions(-)
 create mode 100644 include/dt-bindings/clock/stih416-clks.h

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index 10f8389..c4e5d42 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -7,8 +7,13 @@
  * published by the Free Software Foundation.
  */
 
+#include <dt-bindings/clock/stih416-clks.h>
+
 / {
 	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
 
 		/*
 		 * Fixed 30MHz oscillator inputs to SoC
@@ -52,5 +57,475 @@
 			clock-frequency = <25000000>;
 			clock-output-names = "CLK_S_ETH1_PHY";
 		};
+
+		/*
+		 * ClockGenAs on SASG2
+		 */
+		clockgen-a@fee62000 {
+			reg = <0xfee62000 0xb48>;
+
+			clk_s_a0_pll: clk-s-a0-pll {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-plls-c65";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-a0-pll0-hs",
+						     "clk-s-a0-pll0-ls",
+						     "clk-s-a0-pll1";
+			};
+
+			clk_s_a0_osc_prediv: clk-s-a0-osc-prediv {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c65",
+					     "st,clkgena-prediv";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-a0-osc-prediv";
+			};
+
+			clk_s_a0_hs: clk-s-a0-hs {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-hs",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_s_a0_osc_prediv>,
+					 <&clk_s_a0_pll 0>, /* PLL0 HS */
+					 <&clk_s_a0_pll 2>; /* PLL1 */
+
+				clock-output-names = "clk-s-fdma-0",
+						     "clk-s-fdma-1",
+						     ""; /* clk-s-jit-sense */
+						     /* Fourth output unused */
+			};
+
+			clk_s_a0_ls: clk-s-a0-ls {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-ls",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_s_a0_osc_prediv>,
+					 <&clk_s_a0_pll 1>, /* PLL0 LS */
+					 <&clk_s_a0_pll 2>; /* PLL1 */
+
+				clock-output-names = "clk-s-icn-reg-0",
+						     "clk-s-icn-if-0",
+						     "clk-s-icn-reg-lp-0",
+						     "clk-s-emiss",
+						     "clk-s-eth1-phy",
+						     "clk-s-mii-ref-out";
+						     /* Remaining outputs unused */
+			};
+		};
+
+		clockgen-a@fee81000 {
+			reg = <0xfee81000 0xb48>;
+
+			clk_s_a1_pll: clk-s-a1-pll {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-plls-c65";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-a1-pll0-hs",
+						     "clk-s-a1-pll0-ls",
+						     "clk-s-a1-pll1";
+			};
+
+			clk_s_a1_osc_prediv: clk-s-a1-osc-prediv {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c65",
+					     "st,clkgena-prediv";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-a1-osc-prediv";
+			};
+
+			clk_s_a1_hs: clk-s-a1-hs {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-hs",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_s_a1_osc_prediv>,
+					 <&clk_s_a1_pll 0>, /* PLL0 HS */
+					 <&clk_s_a1_pll 2>; /* PLL1 */
+
+				clock-output-names = "", /* Reserved */
+						     "", /* Reserved */
+						     "clk-s-stac-phy",
+						     "clk-s-vtac-tx-phy";
+			};
+
+			clk_s_a1_ls: clk-s-a1-ls {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c65-ls",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_s_a1_osc_prediv>,
+					 <&clk_s_a1_pll 1>, /* PLL0 LS */
+					 <&clk_s_a1_pll 2>; /* PLL1 */
+
+				clock-output-names = "clk-s-icn-if-2",
+						     "clk-s-card-mmc-0",
+						     "clk-s-icn-if-1",
+						     "clk-s-gmac0-phy",
+						     "clk-s-nand-ctrl",
+						     "", /* Reserved */
+						     "clk-s-mii0-ref-out",
+						     "clk-s-stac-sys",
+						     "clk-s-card-mmc-1";
+						     /* Remaining outputs unused */
+			};
+		};
+
+		/*
+		 * ClockGenAs on MPE42
+		 */
+		clockgen-a@fde12000 {
+			reg = <0xfde12000 0xb50>;
+
+			clk_m_a0_pll0: clk-m-a0-pll0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a0-pll0-phi0",
+						     "clk-m-a0-pll0-phi1",
+						     "clk-m-a0-pll0-phi2",
+						     "clk-m-a0-pll0-phi3";
+			};
+
+			clk_m_a0_pll1: clk-m-a0-pll1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a0-pll1-phi0",
+						     "clk-m-a0-pll1-phi1",
+						     "clk-m-a0-pll1-phi2",
+						     "clk-m-a0-pll1-phi3";
+			};
+
+			clk_m_a0_osc_prediv: clk-m-a0-osc-prediv {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a0-osc-prediv";
+			};
+
+			clk_m_a0_div0: clk-m-a0-div0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a0_osc_prediv>,
+					 <&clk_m_a0_pll0 0>, /* PLL0 PHI0 */
+					 <&clk_m_a0_pll1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "clk-m-fdma-12",
+						     "", /* Unused */
+						     "clk-m-pp-dmu-0",
+						     "clk-m-pp-dmu-1",
+						     "clk-m-icm-lmi",
+						     "clk-m-vid-dmu-0";
+			};
+
+			clk_m_a0_div1: clk-m-a0-div1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a0_osc_prediv>,
+					 <&clk_m_a0_pll0 1>, /* PLL0 PHI1 */
+					 <&clk_m_a0_pll1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "clk-m-vid-dmu-1",
+						     "", /* Unused */
+						     "clk-m-a9-ext2f",
+						     "clk-m-st40rt",
+						     "clk-m-st231-dmu-0",
+						     "clk-m-st231-dmu-1",
+						     "clk-m-st231-aud",
+						     "clk-m-st231-gp-0";
+			};
+
+			clk_m_a0_div2: clk-m-a0-div2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a0_osc_prediv>,
+					 <&clk_m_a0_pll0 2>, /* PLL0 PHI2 */
+					 <&clk_m_a0_pll1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "clk-m-st231-gp-1",
+						     "clk-m-icn-cpu",
+						     "clk-m-icn-stac",
+						     "clk-m-tx-icn-dmu-0",
+						     "clk-m-tx-icn-dmu-1",
+						     "clk-m-tx-icn-ts",
+						     "clk-m-icn-vdp-0",
+						     "clk-m-icn-vdp-1";
+			};
+
+			clk_m_a0_div3: clk-m-a0-div3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a0_osc_prediv>,
+					 <&clk_m_a0_pll0 3>, /* PLL0 PHI3 */
+					 <&clk_m_a0_pll1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "clk-m-icn-vp8",
+						     "", /* Unused */
+						     "clk-m-icn-reg-11",
+						     "clk-m-a9-trace";
+			};
+		};
+
+		clockgen-a@fd6db000 {
+			reg = <0xfd6db000 0xb50>;
+
+			clk_m_a1_pll0: clk-m-a1-pll0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a1-pll0-phi0",
+						     "clk-m-a1-pll0-phi1",
+						     "clk-m-a1-pll0-phi2",
+						     "clk-m-a1-pll0-phi3";
+			};
+
+			clk_m_a1_pll1: clk-m-a1-pll1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a1-pll1-phi0",
+						     "clk-m-a1-pll1-phi1",
+						     "clk-m-a1-pll1-phi2",
+						     "clk-m-a1-pll1-phi3";
+			};
+
+			clk_m_a1_osc_prediv: clk-m-a1-osc-prediv {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a1-osc-prediv";
+			};
+
+			clk_m_a1_div0: clk-m-a1-div0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a1_osc_prediv>,
+					 <&clk_m_a1_pll0 0>, /* PLL0 PHI0 */
+					 <&clk_m_a1_pll1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "", /* Unused */
+						     "clk-m-fdma-10",
+						     "clk-m-fdma-11",
+						     "clk-m-hva-alt",
+						     "clk-m-proc-sc",
+						     "clk-m-tp",
+						     "clk-m-rx-icn-dmu-0",
+						     "clk-m-rx-icn-dmu-1";
+			};
+
+			clk_m_a1_div1: clk-m-a1-div1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a1_osc_prediv>,
+					 <&clk_m_a1_pll0 1>, /* PLL0 PHI1 */
+					 <&clk_m_a1_pll1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "clk-m-rx-icn-ts",
+						     "clk-m-rx-icn-vdp-0",
+						     "", /* Unused */
+						     "clk-m-prv-t1-bus",
+						     "clk-m-icn-reg-12",
+						     "clk-m-icn-reg-10",
+						     "", /* Unused */
+						     "clk-m-icn-st231";
+			};
+
+			clk_m_a1_div2: clk-m-a1-div2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a1_osc_prediv>,
+					 <&clk_m_a1_pll0 2>, /* PLL0 PHI2 */
+					 <&clk_m_a1_pll1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "clk-m-fvdp-proc-alt",
+						     "clk-m-icn-reg-13",
+						     "clk-m-tx-icn-gpu",
+						     "clk-m-rx-icn-gpu",
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* clk-m-apb-pm-12 */
+						     ""; /* Unused */
+			};
+
+			clk_m_a1_div3: clk-m-a1-div3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a1_osc_prediv>,
+					 <&clk_m_a1_pll0 3>, /* PLL0 PHI3 */
+					 <&clk_m_a1_pll1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     "", /* Unused */
+						     ""; /* clk-m-gpu-alt */
+			};
+		};
+
+		clk_m_a9_ext2f_div2: clk-m-a9-ext2f-div2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&clk_m_a0_div1 2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		clockgen-a@fd345000 {
+			reg = <0xfd345000 0xb50>;
+
+			clk_m_a2_pll0: clk-m-a2-pll0 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a2-pll0-phi0",
+						     "clk-m-a2-pll0-phi1",
+						     "clk-m-a2-pll0-phi2",
+						     "clk-m-a2-pll0-phi3";
+			};
+
+			clk_m_a2_pll1: clk-m-a2-pll1 {
+				#clock-cells = <1>;
+				compatible = "st,plls-c32-a1x-1", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a2-pll1-phi0",
+						     "clk-m-a2-pll1-phi1",
+						     "clk-m-a2-pll1-phi2",
+						     "clk-m-a2-pll1-phi3";
+			};
+
+			clk_m_a2_osc_prediv: clk-m-a2-osc-prediv {
+				#clock-cells = <0>;
+				compatible = "st,clkgena-prediv-c32",
+					     "st,clkgena-prediv";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-m-a2-osc-prediv";
+			};
+
+			clk_m_a2_div0: clk-m-a2-div0 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf0",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a2_osc_prediv>,
+					 <&clk_m_a2_pll0 0>, /* PLL0 PHI0 */
+					 <&clk_m_a2_pll1 0>; /* PLL1 PHI0 */
+
+				clock-output-names = "clk-m-vtac-main-phy",
+						     "clk-m-vtac-aux-phy",
+						     "clk-m-stac-phy",
+						     "clk-m-stac-sys",
+						     "", /* clk-m-mpestac-pg */
+						     "", /* clk-m-mpestac-wc */
+						     "", /* clk-m-mpevtacaux-pg*/
+						     ""; /* clk-m-mpevtacmain-pg*/
+			};
+
+			clk_m_a2_div1: clk-m-a2-div1 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf1",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a2_osc_prediv>,
+					 <&clk_m_a2_pll0 1>, /* PLL0 PHI1 */
+					 <&clk_m_a2_pll1 1>; /* PLL1 PHI1 */
+
+				clock-output-names = "", /* clk-m-mpevtacrx0-wc */
+						     "", /* clk-m-mpevtacrx1-wc */
+						     "clk-m-compo-main",
+						     "clk-m-compo-aux",
+						     "clk-m-bdisp-0",
+						     "clk-m-bdisp-1",
+						     "clk-m-icn-bdisp",
+						     "clk-m-icn-compo";
+			};
+
+			clk_m_a2_div2: clk-m-a2-div2 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf2",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a2_osc_prediv>,
+					 <&clk_m_a2_pll0 2>, /* PLL0 PHI2 */
+					 <&clk_m_a2_pll1 2>; /* PLL1 PHI2 */
+
+				clock-output-names = "clk-m-icn-vdp-2",
+						     "", /* Unused */
+						     "clk-m-icn-reg-14",
+						     "clk-m-mdtp",
+						     "clk-m-jpegdec",
+						     "", /* Unused */
+						     "clk-m-dcephy-impctrl",
+						     ""; /* Unused */
+			};
+
+			clk_m_a2_div3: clk-m-a2-div3 {
+				#clock-cells = <1>;
+				compatible = "st,clkgena-divmux-c32-odf3",
+					     "st,clkgena-divmux";
+
+				clocks = <&clk_m_a2_osc_prediv>,
+					 <&clk_m_a2_pll0 3>, /* PLL0 PHI3 */
+					 <&clk_m_a2_pll1 3>; /* PLL1 PHI3 */
+
+				clock-output-names = "", /* Unused */
+						     ""; /* clk-m-apb-pm-11 */
+						     /* Remaining outputs unused */
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index cc616b4..3e507f63 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -89,7 +89,7 @@
 			status 		= "disabled";
 			reg		= <0xfed32000 0x2c>;
 			interrupts	= <0 197 0>;
-			clocks          = <&CLK_S_ICN_REG_0>;
+			clocks 		= <&clk_s_a0_ls CLK_ICN_REG>;
 			pinctrl-names 	= "default";
 			pinctrl-0 	= <&pinctrl_serial2 &pinctrl_serial2_oe>;
 		};
@@ -109,7 +109,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed40000 0x110>;
 			interrupts	= <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_S_ICN_REG_0>;
+			clocks 		= <&clk_s_a0_ls CLK_ICN_REG>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -122,7 +122,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfed41000 0x110>;
 			interrupts	= <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_S_ICN_REG_0>;
+			clocks 		= <&clk_s_a0_ls CLK_ICN_REG>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -176,7 +176,7 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii0>;
 			clock-names	= "stmmaceth";
-			clocks		= <&CLK_S_GMAC0_PHY>;
+			clocks		= <&clk_s_a1_ls CLK_GMAC0_PHY>;
 		};
 
 		ethernet1: dwmac@fef08000 {
@@ -198,7 +198,7 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii1>;
 			clock-names	= "stmmaceth";
-			clocks		= <&CLK_S_ETH1_PHY>;
+			clocks		= <&clk_s_a0_ls CLK_ETH1_PHY>;
 		};
 
 		rc: rc@fe518000 {
diff --git a/include/dt-bindings/clock/stih416-clks.h b/include/dt-bindings/clock/stih416-clks.h
new file mode 100644
index 0000000..552c779
--- /dev/null
+++ b/include/dt-bindings/clock/stih416-clks.h
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
-- 
1.9.1


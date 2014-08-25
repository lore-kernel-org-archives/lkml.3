Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaHYOv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:51:27 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48178 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233AbaHYOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:13 -0400
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
        Olivier Bideau <olivier.bideau@st.com>
Subject: [RESEND PATCH 2/4] ARM: STi: DT: STiH407: 407 DT Entry for clockgen C0
Date: Mon, 25 Aug 2014 16:44:46 +0200
Message-Id: <1408977888-10473-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-25_01:2014-08-25,2014-08-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen C0

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
---
 arch/arm/boot/dts/stih407-clock.dtsi     | 94 ++++++++++++++++++++++++++++----
 arch/arm/boot/dts/stih407.dtsi           | 18 +++---
 include/dt-bindings/clock/stih407-clks.h | 11 ++++
 3 files changed, 103 insertions(+), 20 deletions(-)
 create mode 100644 include/dt-bindings/clock/stih407-clks.h

diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
index e03e86e..85cc135 100644
--- a/arch/arm/boot/dts/stih407-clock.dtsi
+++ b/arch/arm/boot/dts/stih407-clock.dtsi
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <dt-bindings/clock/stih407-clks.h>
 / {
 	clocks {
 		#address-cells = <1>;
@@ -30,17 +31,6 @@
 		};
 
 		/*
-		 * Bootloader initialized system infrastructure clock for
-		 * serial devices.
-		 */
-		clk_ext2f_a9: clockgen-c0@13 {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <200000000>;
-			clock-output-names = "clk-s-icn-reg-0";
-		};
-
-		/*
 		 * ClockGenAs on SASG2
 		 */
 		clockgen-a@090ff000 {
@@ -67,5 +57,87 @@
 				clock-output-names = "clk-ic-lmi0";
 			};
 		};
+
+		clk_s_c0_quadfs: clk-s-c0-quadfs@9103000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-C", "st,quadfs";
+			reg = <0x9103000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-c0-fs0-ch0",
+					     "clk-s-c0-fs0-ch1",
+					     "clk-s-c0-fs0-ch2",
+					     "clk-s-c0-fs0-ch3";
+		};
+
+		clk_s_c0: clockgen-c@09103000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9103000 0x1000>;
+
+			clk_s_c0_pll0: clk-s-c0-pll0 {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-c0_0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-c0-pll0-odf-0";
+			};
+
+			clk_s_c0_pll1: clk-s-c0-pll1 {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-c0_1", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-c0-pll1-odf-0";
+			};
+
+			clk_s_c0_flexgen: clk-s-c0-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_c0_pll0 0>,
+					 <&clk_s_c0_pll1 0>,
+					 <&clk_s_c0_quadfs 0>,
+					 <&clk_s_c0_quadfs 1>,
+					 <&clk_s_c0_quadfs 2>,
+					 <&clk_s_c0_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-icn-gpu",
+						     "clk-fdma",
+						     "clk-nand",
+						     "clk-hva",
+						     "clk-proc-stfe",
+						     "clk-proc-tp",
+						     "clk-rx-icn-dmu",
+						     "clk-rx-icn-hva",
+						     "clk-icn-cpu",
+						     "clk-tx-icn-dmu",
+						     "clk-mmc-0",
+						     "clk-mmc-1",
+						     "clk-jpegdec",
+						     "clk-ext2fa9",
+						     "clk-ic-bdisp-0",
+						     "clk-ic-bdisp-1",
+						     "clk-pp-dmu",
+						     "clk-vid-dmu",
+						     "clk-dss-lpc",
+						     "clk-st231-aud-0",
+						     "clk-st231-gp-1",
+						     "clk-st231-dmu",
+						     "clk-icn-lmi",
+						     "clk-tx-icn-disp-1",
+						     "clk-icn-sbc",
+						     "clk-stfe-frc2",
+						     "clk-eth-phy",
+						     "clk-eth-ref-phyclk",
+						     "clk-flash-promip",
+						     "clk-main-disp",
+						     "clk-aux-disp",
+						     "clk-compo-dvp";
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..f539627 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -104,7 +104,7 @@
 			interrupts = <GIC_SPI 122 IRQ_TYPE_NONE>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_serial0>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 
 			status = "disabled";
 		};
@@ -115,7 +115,7 @@
 			interrupts = <GIC_SPI 123 IRQ_TYPE_NONE>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_serial1>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 
 			status = "disabled";
 		};
@@ -126,7 +126,7 @@
 			interrupts = <GIC_SPI 124 IRQ_TYPE_NONE>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_serial2>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 
 			status = "disabled";
 		};
@@ -158,7 +158,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
 			reg = <0x9840000 0x110>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
@@ -171,7 +171,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			reg = <0x9841000 0x110>;
 			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
@@ -184,7 +184,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			reg = <0x9842000 0x110>;
 			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
@@ -197,7 +197,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			reg = <0x9843000 0x110>;
 			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
@@ -210,7 +210,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			reg = <0x9844000 0x110>;
 			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
@@ -223,7 +223,7 @@
 			compatible = "st,comms-ssc4-i2c";
 			reg = <0x9845000 0x110>;
 			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_ext2f_a9>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
 			clock-names = "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names = "default";
diff --git a/include/dt-bindings/clock/stih407-clks.h b/include/dt-bindings/clock/stih407-clks.h
new file mode 100644
index 0000000..1f9bfe0
--- /dev/null
+++ b/include/dt-bindings/clock/stih407-clks.h
@@ -0,0 +1,11 @@
+/*
+ * This header provides constants clk index STMicroelectronics
+ * STiH407 SoC.
+ */
+#ifndef _DT_BINDINGS_CLK_STIH407
+#define _DT_BINDINGS_CLK_STIH407
+
+/* CLOCKGEN C0 */
+#define CLK_EXT2F_A9		13
+
+#endif
-- 
1.9.1


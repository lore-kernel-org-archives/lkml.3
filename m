Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbaDKNUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:20:32 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45817 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747AbaDKNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:20:27 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: linux-kernel@vger.kernel.org, patrice.chotard@st.com,
        maxime.coquelin@st.com
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        mturquette@linaro.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH 5/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
Date: Fri, 11 Apr 2014 15:19:52 +0200
Message-Id: <1397222396-30106-6-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397222396-30106-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1397222396-30106-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_04:2014-04-11,2014-04-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A9/DDR/GPU

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-clock.dtsi | 79 ++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index 7ff107b..d68860f 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -26,15 +26,6 @@
 		};
 
 		/*
-		 * ARM Peripheral clock for timers
-		 */
-		arm_periph_clk: arm_periph_clk {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <600000000>;
-		};
-
-		/*
 		 * ClockGenAs on SASG2
 		 */
 		clockgenA@fee62000 {
@@ -505,6 +496,45 @@
 		};
 
 		/*
+		 * A9 PLL
+		 */
+		clockgenA9 {
+			reg = <0xfdde08b0 0x70>;
+
+			CLOCKGEN_A9_PLL: CLOCKGEN_A9_PLL {
+				#clock-cells = <1>;
+				compatible = "st,stih416-plls-c32-a9", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+				clock-output-names = "CLOCKGEN_A9_PLL_ODF";
+			};
+		};
+
+		/*
+		 * ARM CPU related clocks
+		 */
+		CLK_M_A9: CLK_M_A9 {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0xfdde08ac 0x4>;
+			clocks = <&CLOCKGEN_A9_PLL 0>,
+				     <&CLOCKGEN_A9_PLL 0>,
+					 <&CLK_M_A0_DIV1 2>,
+					 <&CLK_M_A9_EXT2F_DIV2>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: CLK_M_A9_PERIPHS {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&CLK_M_A9>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		/*
 		 * Frequency synthesizers on the SASG2
 		 */
 		CLOCKGEN_B0: CLOCKGEN_B0 {
@@ -692,5 +722,36 @@
 					      "CLK_M_PIX_HDMIRX_0",
 					      "CLK_M_PIX_HDMIRX_1";
 		};
+
+		/*
+		 * DDR PLL
+		 */
+		clockgenDDR {
+			reg = <0xfdde07d8 0x110>;
+
+			CLOCKGEN_DDR_PLL: CLOCKGEN_DDR_PLL {
+				#clock-cells = <1>;
+				compatible = "st,stih416-plls-c32-ddr", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+				clock-output-names = "CLOCKGEN_DDR0",
+									 "CLOCKGEN_DDR1";
+			};
+		};
+
+		/*
+		 * GPU PLL
+		 */
+		clockgenGPU {
+			reg = <0xfd68ff00 0x910>;
+
+			CLOCKGEN_GPU_PLL: CLOCKGEN_GPU_PLL {
+				#clock-cells = <1>;
+				compatible = "st,stih416-gpu-pll-c32", "st,clkgengpu-pll-c32";
+
+				clocks = <&CLK_SYSIN>;
+				clock-output-names = "CLOCKGEN_GPU_PLL";
+			};
+		};
 	};
 };
-- 
1.9.1


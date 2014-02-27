Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaB0P0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:26:49 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:54280 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbaB0P0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:26:46 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v0 13/15] ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
Date: Thu, 27 Feb 2014 16:24:26 +0100
Message-Id: <1393514668-17440-14-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A9/DDR/GPU

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
---
 arch/arm/boot/dts/stih416-clock.dtsi | 79 ++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index 6b2e387..5ff0e6f 100644
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
@@ -503,6 +494,44 @@
 						/* Remaining outputs unused */
 			};
 		};
+
+		/*
+		 * A9 PLL.
+		 *
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
+		 * ARM CPU related clocks.
+		 */
+		CLK_M_A9: CLK_M_A9 {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0xfdde08ac 0x4>;
+			clocks = <&CLOCKGEN_A9_PLL 0>, <&CLOCKGEN_A9_PLL 0>, <&CLK_M_A0_DIV1 2>, <&CLK_M_A9_EXT2F_DIV2>;
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
                 /*
                  * Frequency synthesizers on the SASG2.
                  *
@@ -673,5 +702,37 @@
                                 "CLK_M_XFER_AUX_COMPO", "CLK_M_VSENS",
                                 "CLK_M_PIX_HDMIRX_0",   "CLK_M_PIX_HDMIRX_1";
                 };
+
+		/*
+		 * DDR PLL.
+		 *
+		 */
+		clockgenDDR {
+			reg = <0xfdde07d8 0x110>;
+
+			CLOCKGEN_DDR_PLL: CLOCKGEN_DDR_PLL {
+				#clock-cells = <1>;
+				compatible = "st,stih416-plls-c32-ddr", "st,clkgen-plls-c32";
+
+				clocks = <&CLK_SYSIN>;
+				clock-output-names = "CLOCKGEN_DDR0", "CLOCKGEN_DDR1";
+			};
+		};
+
+		/*
+		 * GPU PLL.
+		 *
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
1.9.0


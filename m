Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaB0PtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:20 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56999 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbaB0PtR (ORCPT
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
Subject: [PATCH v0 15/15] ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
Date: Thu, 27 Feb 2014 16:24:28 +0100
Message-Id: <1393514668-17440-16-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A9

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/stih415-clock.dtsi | 67 +++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-clock.dtsi b/arch/arm/boot/dts/stih415-clock.dtsi
index 24a7508..8563636 100644
--- a/arch/arm/boot/dts/stih415-clock.dtsi
+++ b/arch/arm/boot/dts/stih415-clock.dtsi
@@ -24,15 +24,6 @@
 		};
 
 		/*
-		 * ARM Peripheral clock for timers
-		 */
-		arm_periph_clk: arm_periph_clk {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <500000000>;
-		};
-
-		/*
 		 * ClockGenAs on SASG1
 		 */
 		clockgenA@fee62000 {
@@ -499,5 +490,63 @@
 						/* Remaining outputs unused */
 			};
 		};
+
+		/*
+		 * A9 PLL.
+		 *
+		 */
+		clockgenA9 {
+			reg = <0xfdde00d8 0x70>;
+
+			CLOCKGEN_A9_PLL: CLOCKGEN_A9_PLL {
+				#clock-cells = <1>;
+				compatible = "st,stih415-plls-c32-a9", "st,clkgen-plls-c32";
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
+			compatible = "st,stih415-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0xfdde00d8 0x4>;
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
+		CLK_S_USB48: clockgenB0@0 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			clock-output-names = "CLK_S_USB48";
+		};
+
+		CLKS_B_THSENS: clockgenB@3 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <996000>;
+			clock-output-names = "CLKS_B_THSENS";
+		};
+
+		CLKM_MPETHSENS: clockgenE@3 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <996000>;
+			clock-output-names = "CLKM_MPETHSENS";
+		};
 	};
 };
-- 
1.9.0


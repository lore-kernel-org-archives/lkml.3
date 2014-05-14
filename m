Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaENNZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:25:39 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:34504 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbaENNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:25:31 -0400
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
Subject: [PATCH v2 09/10] ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
Date: Wed, 14 May 2014 15:24:17 +0200
Message-Id: <1400073858-28912-10-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400073858-28912-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1400073858-28912-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-14_03:2014-05-14,2014-05-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A9

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih415-clock.dtsi | 48 +++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-clock.dtsi b/arch/arm/boot/dts/stih415-clock.dtsi
index 8618851..5d161ee 100644
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
@@ -499,5 +490,44 @@
 						/* Remaining outputs unused */
 			};
 		};
+
+		/*
+		 * A9 PLL
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
+		 * ARM CPU related clocks
+		 */
+		CLK_M_A9: CLK_M_A9 {
+			#clock-cells = <0>;
+			compatible = "st,stih415-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0xfdde00d8 0x4>;
+			clocks = <&CLOCKGEN_A9_PLL 0>,
+				 <&CLOCKGEN_A9_PLL 0>,
+				 <&CLK_M_A0_DIV1 2>,
+				 <&CLK_M_A9_EXT2F_DIV2>;
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
 	};
 };
-- 
1.9.1


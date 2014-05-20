Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaETN0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:26:15 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36084 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbaETNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:14 -0400
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
Subject: [PATCH v3 10/11] ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
Date: Tue, 20 May 2014 15:22:54 +0200
Message-Id: <1400592175-13176-11-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
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
index 637caa8..3ee3451 100644
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
 		clockgen-a@fee62000 {
@@ -499,5 +490,44 @@
 						/* Remaining outputs unused */
 			};
 		};
+
+		/*
+		 * A9 PLL
+		 */
+		clockgen-a9@fdde00d8 {
+			reg = <0xfdde00d8 0x70>;
+
+			clockgen_a9_pll: clockgen-a9-pll {
+				#clock-cells = <1>;
+				compatible = "st,stih415-plls-c32-a9", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+				clock-output-names = "clockgen-a9-pll-odf";
+			};
+		};
+
+		/*
+		 * ARM CPU related clocks
+		 */
+		clk_m_a9: clk-m-a9@fdde00d8 {
+			#clock-cells = <0>;
+			compatible = "st,stih415-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0xfdde00d8 0x4>;
+			clocks = <&clockgen_a9_pll 0>,
+				 <&clockgen_a9_pll 0>,
+				 <&clk_m_a0_div1 2>,
+				 <&clk_m_a9_ext2f_div2>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: clk-m-a9-periphs {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&clk_m_a9>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
 	};
 };
-- 
1.9.1


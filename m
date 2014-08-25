Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbaHYOqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:14 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35030 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030AbaHYOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:10 -0400
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
Subject: [RESEND PATCH 4/4] ARM: STi: DT: STiH407: 407 DT Entry for clockgenA9
Date: Mon, 25 Aug 2014 16:44:48 +0200
Message-Id: <1408977888-10473-5-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-25_01:2014-08-25,2014-08-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen A9

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
---
 arch/arm/boot/dts/stih407-clock.dtsi | 55 ++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
index 6e59011..b4318e1 100644
--- a/arch/arm/boot/dts/stih407-clock.dtsi
+++ b/arch/arm/boot/dts/stih407-clock.dtsi
@@ -24,10 +24,59 @@
 		/*
 		 * ARM Peripheral clock for timers
 		 */
-		arm_periph_clk: arm-periph-clk {
+		arm_periph_clk: clk-m-a9-periphs {
 			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <600000000>;
+			compatible = "fixed-factor-clock";
+
+			clocks = <&clk_m_a9>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		/*
+		 * A9 PLL.
+		 */
+		clockgen-a9@92b0000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x92b0000 0xffff>;
+
+			clockgen_a9_pll: clockgen-a9-pll {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-a9", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clockgen-a9-pll-odf";
+			};
+		};
+
+		/*
+		 * ARM CPU related clocks.
+		 */
+		clk_m_a9: clk-m-a9@92b0000 {
+			#clock-cells = <0>;
+			compatible = "st,stih407-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0x92b0000 0x10000>;
+
+			clocks = <&clockgen_a9_pll 0>,
+				 <&clockgen_a9_pll 0>,
+				 <&clk_s_c0_flexgen 13>,
+				 <&clk_m_a9_ext2f_div2>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		clk_m_a9_ext2f_div2: clk-m-a9-ext2f-div2s {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+
+			clocks = <&clk_s_c0_flexgen 13>;
+
+			clock-output-names = "clk-m-a9-ext2f-div2";
+
+			clock-div = <2>;
+			clock-mult = <1>;
 		};
 
 		/*
-- 
1.9.1


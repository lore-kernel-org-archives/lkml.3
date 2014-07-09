Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaGIPNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:13:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43102 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaGIPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:07 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, chris@printf.net, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, peppe.cavallaro@st.com
Subject: [PATCH v4 03/10] ARM: STi: DT: Add sdhci pins for stih416
Date: Wed,  9 Jul 2014 16:07:34 +0100
Message-Id: <1404918461-25390-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the required pin config for both SDHCI controllers on
the stih416 SoC.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index ee6c119..01b5ad0 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -467,6 +467,45 @@
 					};
 				};
 			};
+
+			mmc0 {
+				pinctrl_mmc0: mmc0 {
+					st,pins {
+						mmcclk  = <&PIO13 4 ALT4 BIDIR_PU NICLK 0 CLK_B>;
+						data0   = <&PIO14 4 ALT4 BIDIR_PU BYPASS 0>;
+						data1   = <&PIO14 5 ALT4 BIDIR_PU BYPASS 0>;
+						data2   = <&PIO14 6 ALT4 BIDIR_PU BYPASS 0>;
+						data3   = <&PIO14 7 ALT4 BIDIR_PU BYPASS 0>;
+						cmd     = <&PIO15 1 ALT4 BIDIR_PU BYPASS 0>;
+						wp      = <&PIO15 3 ALT4 IN>;
+						data4   = <&PIO16 4 ALT4 BIDIR_PU BYPASS 0>;
+						data5   = <&PIO16 5 ALT4 BIDIR_PU BYPASS 0>;
+						data6   = <&PIO16 6 ALT4 BIDIR_PU BYPASS 0>;
+						data7   = <&PIO16 7 ALT4 BIDIR_PU BYPASS 0>;
+						pwr     = <&PIO17 1 ALT4 OUT>;
+						cd      = <&PIO17 2 ALT4 IN>;
+						led     = <&PIO17 3 ALT4 OUT>;
+					};
+				};
+			};
+			mmc1 {
+				pinctrl_mmc1: mmc1 {
+					st,pins {
+						mmcclk  = <&PIO15 0 ALT3 BIDIR_PU NICLK 0 CLK_B>;
+						data0   = <&PIO13 7 ALT3 BIDIR_PU BYPASS 0>;
+						data1   = <&PIO14 1 ALT3 BIDIR_PU BYPASS 0>;
+						data2   = <&PIO14 2 ALT3 BIDIR_PU BYPASS 0>;
+						data3   = <&PIO14 3 ALT3 BIDIR_PU BYPASS 0>;
+						cmd     = <&PIO15 4 ALT3 BIDIR_PU BYPASS 0>;
+						data4   = <&PIO15 6 ALT3 BIDIR_PU BYPASS 0>;
+						data5   = <&PIO15 7 ALT3 BIDIR_PU BYPASS 0>;
+						data6   = <&PIO16 0 ALT3 BIDIR_PU BYPASS 0>;
+						data7   = <&PIO16 1 ALT3 BIDIR_PU BYPASS 0>;
+						pwr     = <&PIO16 2 ALT3 OUT>;
+						nreset  = <&PIO13 6 ALT3 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-fvdp-fe {
-- 
1.9.1


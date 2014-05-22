Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaEVPUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:20:24 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49814 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaEVPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:18:48 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, kernel@stlinux.com, lee.jones@linaro.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 3/8] ARM: STi: DT: Add sdhci pins for stih416
Date: Thu, 22 May 2014 16:18:17 +0100
Message-Id: <1400771902-26553-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the required pin config for both SDHCI controllers on
the stih416 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 6252188..140af6b 100644
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
+						mmcclk = <&PIO13 4 ALT4 BIDIR_PU NICLK 0 CLK_B>;
+						data0 = <&PIO14 4 ALT4 BIDIR_PU BYPASS 0>;
+						data1 = <&PIO14 5 ALT4 BIDIR_PU BYPASS 0>;
+						data2 = <&PIO14 6 ALT4 BIDIR_PU BYPASS 0>;
+						data3 = <&PIO14 7 ALT4 BIDIR_PU BYPASS 0>;
+						cmd = <&PIO15 1 ALT4 BIDIR_PU BYPASS 0>;
+						wp = <&PIO15 3 ALT4 IN>;
+						data4 = <&PIO16 4 ALT4 BIDIR_PU BYPASS 0>;
+						data5 = <&PIO16 5 ALT4 BIDIR_PU BYPASS 0>;
+						data6 = <&PIO16 6 ALT4 BIDIR_PU BYPASS 0>;
+						data7 = <&PIO16 7 ALT4 BIDIR_PU BYPASS 0>;
+						pwr = <&PIO17 1 ALT4 OUT>;
+						cd = <&PIO17 2 ALT4 IN>;
+						led = <&PIO17 3 ALT4 OUT>;
+					};
+				};
+			};
+			mmc1 {
+				pinctrl_mmc1: mmc1 {
+					st,pins {
+						mmcclk = <&PIO15 0 ALT3 BIDIR_PU NICLK 0 CLK_B>;
+						data0 = <&PIO13 7 ALT3 BIDIR_PU BYPASS 0>;
+						data1 = <&PIO14 1 ALT3 BIDIR_PU BYPASS 0>;
+						data2 = <&PIO14 2 ALT3 BIDIR_PU BYPASS 0>;
+						data3 = <&PIO14 3 ALT3 BIDIR_PU BYPASS 0>;
+						cmd = <&PIO15 4 ALT3 BIDIR_PU BYPASS 0>;
+						data4 = <&PIO15 6 ALT3 BIDIR_PU BYPASS 0>;
+						data5 = <&PIO15 7 ALT3 BIDIR_PU BYPASS 0>;
+						data6 = <&PIO16 0 ALT3 BIDIR_PU BYPASS 0>;
+						data7 = <&PIO16 1 ALT3 BIDIR_PU BYPASS 0>;
+						pwr = <&PIO16 2 ALT3 OUT>;
+						nreset = <&PIO13 6 ALT3 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-fvdp-fe {
-- 
1.9.1


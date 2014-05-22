Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaEVPS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:18:57 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61370 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaEVPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:18:53 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, kernel@stlinux.com, lee.jones@linaro.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 5/8] ARM: STi: DT: Add sdhci pin configuration for stih415
Date: Thu, 22 May 2014 16:18:19 +0100
Message-Id: <1400771902-26553-6-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pin config for the sdhci controller
present in the stih415 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi | 21 +++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         | 12 ++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index caeac7e..eee2373 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -429,6 +429,27 @@
 					};
 				};
 			};
+
+			mmc0 {
+				pinctrl_mmc0: mmc0 {
+					st,pins {
+						mmcclk = <&PIO13 4 ALT4 BIDIR_PU NICLK 0 CLK_B>;
+						data0  = <&PIO14 4 ALT4 BIDIR_PU BYPASS 0>;
+						data1  = <&PIO14 5 ALT4 BIDIR_PU BYPASS 0>;
+						data2  = <&PIO14 6 ALT4 BIDIR_PU BYPASS 0>;
+						data3  = <&PIO14 7 ALT4 BIDIR_PU BYPASS 0>;
+						cmd    = <&PIO15 1 ALT4 BIDIR_PU BYPASS 0>;
+						wp     = <&PIO15 3 ALT4 IN>;
+						data4  = <&PIO16 4 ALT4 BIDIR_PU BYPASS 0>;
+						data5  = <&PIO16 5 ALT4 BIDIR_PU BYPASS 0>;
+						data6  = <&PIO16 6 ALT4 BIDIR_PU BYPASS 0>;
+						data7  = <&PIO16 7 ALT4 BIDIR_PU BYPASS 0>;
+						pwr    = <&PIO17 1 ALT4 OUT>;
+						cd     = <&PIO17 2 ALT4 IN>;
+						led    = <&PIO17 3 ALT4 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-left {
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index d6f254f..6579b1d 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -218,5 +218,17 @@
 			resets	= <&powerdown STIH415_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH415_KEYSCAN_SOFTRESET>;
 		};
+
+		mmc0: sdhci@fe81e000 {
+			compatible = "st,sdhci";
+			status = "disabled";
+			reg = <0xfe81e000 0x1000>;
+			interrupts = <GIC_SPI 145 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_mmc0>;
+			clock-names = "mmc";
+			clocks = <&clk_s_a1_ls 1>;
+		};
 	};
 };
-- 
1.9.1


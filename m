Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaEVPSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:18:53 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40288 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEVPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:18:50 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, kernel@stlinux.com, lee.jones@linaro.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 4/8] ARM: STi: DT: Add sdhci controller for stih416
Date: Thu, 22 May 2014 16:18:18 +0100
Message-Id: <1400771902-26553-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree config for both sdhci controllers
on the stih416 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 arch/arm/boot/dts/stih416.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 06473c5..a035df0 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -236,5 +236,29 @@
 			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
 		};
+
+		mmc0: sdhci@fe81e000 {
+			compatible = "st,sdhci";
+			status = "disabled";
+			reg = <0xfe81e000 0x1000>;
+			interrupts = <GIC_SPI 127 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_mmc0>;
+			clock-names     = "mmc";
+			clocks = <&clk_s_a1_ls 1>;
+		};
+
+		mmc1: sdhci@fe81f000 {
+			compatible = "st,sdhci";
+			status = "disabled";
+			reg = <0xfe81f000 0x1000>;
+			interrupts = <GIC_SPI 128 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_mmc1>;
+			clock-names     = "mmc";
+			clocks = <&clk_s_a1_ls 8>;
+		};
 	};
 };
-- 
1.9.1


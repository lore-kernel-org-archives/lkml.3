Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaGIPIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:08:14 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52995 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaGIPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:11 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, chris@printf.net, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, peppe.cavallaro@st.com
Subject: [PATCH v4 04/10] ARM: STi: DT: Add sdhci controller for stih416
Date: Wed,  9 Jul 2014 16:07:35 +0100
Message-Id: <1404918461-25390-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree config for both sdhci controllers
on the stih416 SoC.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih416.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 84758d7..98c43cc 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -236,5 +236,29 @@
 			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
 		};
+
+		mmc0: sdhci@fe81e000 {
+			compatible	= "st,sdhci";
+			status		= "disabled";
+			reg		= <0xfe81e000 0x1000>;
+			interrupts	= <GIC_SPI 127 IRQ_TYPE_NONE>;
+			interrupt-names	= "mmcirq";
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_mmc0>;
+			clock-names	= "mmc";
+			clocks		= <&clk_s_a1_ls 1>;
+		};
+
+		mmc1: sdhci@fe81f000 {
+			compatible	= "st,sdhci";
+			status		= "disabled";
+			reg		= <0xfe81f000 0x1000>;
+			interrupts	= <GIC_SPI 128 IRQ_TYPE_NONE>;
+			interrupt-names	= "mmcirq";
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_mmc1>;
+			clock-names	= "mmc";
+			clocks		= <&clk_s_a1_ls 8>;
+		};
 	};
 };
-- 
1.9.1


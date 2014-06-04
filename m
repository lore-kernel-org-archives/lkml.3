Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaFDQbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:31:23 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34625 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaFDQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:31:21 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH v3 06/10] ARM: STi: DT: Add sdhci controller for stih415
Date: Wed,  4 Jun 2014 17:30:20 +0100
Message-Id: <1401899424-1365-7-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree config for the sdhci controller
on the stih415 SoC.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih415.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index d6f254f..c81dce4 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -218,5 +218,17 @@
 			resets	= <&powerdown STIH415_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH415_KEYSCAN_SOFTRESET>;
 		};
+
+		mmc0: sdhci@fe81e000 {
+			compatible      = "st,sdhci";
+			status          = "disabled";
+			reg             = <0xfe81e000 0x1000>;
+			interrupts      = <GIC_SPI 145 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names   = "default";
+			pinctrl-0       = <&pinctrl_mmc0>;
+			clock-names     = "mmc";
+			clocks          = <&clk_s_a1_ls 1>;
+		};
 	};
 };
-- 
1.9.1


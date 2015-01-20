Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbbATPdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:33:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56366 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbATPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:33:05 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, mturquette@linaro.org, sboyd@codeaurora.org,
        chris@printf.net, ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, peppe.cavallaro@st.com,
        olivier.bideau@st.com, gabriel.fernandez@st.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 4/4] ARM: STi: DT: STiH407: Add dt nodes for sdhci and emmc.
Date: Tue, 20 Jan 2015 15:32:44 +0000
Message-Id: <1421767964-8798-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
References: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nodes have been split to allow as much commonality as possible.
The stih407 has a silicon bug with eMMC UHS modes (with top regs)
and as such doesn't have any of the uhs dt properties.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 30 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih410-b2120.dts   | 10 ++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi  |  8 ++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index d4a8f84..df0284b 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -283,5 +283,35 @@
 				 <&picophyreset STIH407_PICOPHY0_RESET>;
 			reset-names = "global", "port";
 		};
+
+		mmc0: sdhci@09060000 {
+			compatible = "st,sdhci-stih407", "st,sdhci";
+			status = "disabled";
+			reg = <0x09060000 0x7ff>, <0x9061008 0x20>;
+			reg-names = "mmc", "top-mmc-delay";
+			interrupts = <GIC_SPI 92 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_mmc0>;
+			clock-names = "mmc";
+			clocks = <&clk_s_c0_flexgen CLK_MMC_0>;
+			bus-width = <8>;
+			non-removable;
+		};
+
+		mmc1: sdhci@09080000 {
+			compatible = "st,sdhci-stih407", "st,sdhci";
+			status = "disabled";
+			reg = <0x09080000 0x7ff>;
+			reg-names = "mmc";
+			interrupts = <GIC_SPI 90 IRQ_TYPE_NONE>;
+			interrupt-names = "mmcirq";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sd1>;
+			clock-names = "mmc";
+			clocks = <&clk_s_c0_flexgen CLK_MMC_1>;
+			resets = <&softreset STIH407_MMC1_SOFTRESET>;
+			bus-width = <4>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih410-b2120.dts b/arch/arm/boot/dts/stih410-b2120.dts
index 2f61a99..16f02c5 100644
--- a/arch/arm/boot/dts/stih410-b2120.dts
+++ b/arch/arm/boot/dts/stih410-b2120.dts
@@ -26,4 +26,14 @@
 	aliases {
 		ttyAS0 = &sbc_serial0;
 	};
+
+	soc {
+
+		mmc0: sdhci@09060000 {
+			max-frequency = <200000000>;
+			sd-uhs-sdr50;
+			sd-uhs-sdr104;
+			sd-uhs-ddr50;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 0074bd4..19082ed 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -47,6 +47,14 @@
 			status = "okay";
 		};
 
+		mmc0: sdhci@09060000 {
+			status = "okay";
+		};
+
+		mmc1: sdhci@09080000 {
+			status = "okay";
+		};
+
 		/* SSC11 to HDMI */
 		i2c@9541000 {
 			status = "okay";
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbaLCANr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:13:47 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33489 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbaLCAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 11/12] ARM: dts: add support for Vybrid running on Cortex-M4
Date: Wed,  3 Dec 2014 01:12:10 +0100
Message-Id: <1417565531-4507-12-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an initial device tree to run Linux on the Cortex-M4 on
the Vybrid based Colibri VF61.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/Makefile            |  1 +
 arch/arm/boot/dts/vf610m4-colibri.dts | 52 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/vf610m4.dtsi        | 33 ++++++++++++++++++++++
 3 files changed, 86 insertions(+)
 create mode 100644 arch/arm/boot/dts/vf610m4-colibri.dts
 create mode 100644 arch/arm/boot/dts/vf610m4.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 4600499..a2f3a9e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -67,6 +67,7 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
+dtb-$(CONFIG_SOC_VF610M4) += vf610m4-colibri.dtb
 dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos4210-smdkv310.dtb \
 	exynos4210-trats.dtb \
diff --git a/arch/arm/boot/dts/vf610m4-colibri.dts b/arch/arm/boot/dts/vf610m4-colibri.dts
new file mode 100644
index 0000000..051ee0f
--- /dev/null
+++ b/arch/arm/boot/dts/vf610m4-colibri.dts
@@ -0,0 +1,52 @@
+/*
+ * Device tree for Colibri VF61 Cortex-M4 support
+ *
+ * Copyright 2014 Stefan Agner
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/dts-v1/;
+#include "vf610m4.dtsi"
+
+/ {
+	model = "VF610 Cortex-M4";
+	compatible = "fsl,vf610m4";
+
+	chosen {
+		bootargs = "console=ttyLP2,115200 ihash_entries=64 dhash_entries=64 earlyprintk clk_ignore_unused init=/linuxrc rw";
+	};
+
+	memory {
+		reg = <0x8c000000 0x3000000>;
+	};
+};
+
+&esdhc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_esdhc1>;
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&iomuxc {
+	vf610-colibri {
+		pinctrl_esdhc1: esdhc1grp {
+			fsl,pins = <
+				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
+				VF610_PAD_PTA25__ESDHC1_CMD	0x31ef
+				VF610_PAD_PTA26__ESDHC1_DAT0	0x31ef
+				VF610_PAD_PTA27__ESDHC1_DAT1	0x31ef
+				VF610_PAD_PTA28__ESDHC1_DATA2	0x31ef
+				VF610_PAD_PTA29__ESDHC1_DAT3	0x31ef
+				VF610_PAD_PTB20__GPIO_42	0x219d
+			>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/vf610m4.dtsi b/arch/arm/boot/dts/vf610m4.dtsi
new file mode 100644
index 0000000..6ee6b0c
--- /dev/null
+++ b/arch/arm/boot/dts/vf610m4.dtsi
@@ -0,0 +1,33 @@
+/*
+ * Device tree for VF6xx Cortex-M4 support
+ */
+
+#include "armv7-m.dtsi"
+#include "vfxxx.dtsi"
+
+/ {
+
+	soc {
+		interrupt-parent = <&nvic>;
+	};
+};
+
+&esdhc1 {
+	interrupts = <28>;
+};
+
+&pit {
+	interrupts = <39>;
+};
+
+&uart0 {
+	interrupts = <61>;
+};
+
+&uart1 {
+	interrupts = <62>;
+};
+
+&uart2 {
+	interrupts = <63>;
+};
-- 
2.1.3


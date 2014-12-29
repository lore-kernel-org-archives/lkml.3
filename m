Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaL2XdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:33:24 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41144 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaL2Xc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:28 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 11/12] ARM: dts: add support for Vybrid running on Cortex-M4
Date: Tue, 30 Dec 2014 00:32:14 +0100
Message-Id: <1419895935-22966-12-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an initial device tree to run Linux on the Cortex-M4 on
the Vybrid based Colibri VF61.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/Makefile            |  1 +
 arch/arm/boot/dts/vf610m4-colibri.dts | 52 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/vf610m4.dtsi        | 10 +++++++
 3 files changed, 63 insertions(+)
 create mode 100644 arch/arm/boot/dts/vf610m4-colibri.dts
 create mode 100644 arch/arm/boot/dts/vf610m4.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 91bd5bd..4211dfb 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -271,6 +271,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
 	ls1021a-twr.dtb \
 	vf500-colibri-eval-v3.dtb \
 	vf610-colibri-eval-v3.dtb \
+	vf610m4-colibri.dtb \
 	vf610-cosmic.dtb \
 	vf610-twr.dtb
 dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
diff --git a/arch/arm/boot/dts/vf610m4-colibri.dts b/arch/arm/boot/dts/vf610m4-colibri.dts
new file mode 100644
index 0000000..ebff03e
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
+		bootargs = "console=ttyLP2,115200 clk_ignore_unused init=/linuxrc rw";
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
index 0000000..3d8fa02
--- /dev/null
+++ b/arch/arm/boot/dts/vf610m4.dtsi
@@ -0,0 +1,10 @@
+/*
+ * Device tree for VF6xx Cortex-M4 support
+ */
+
+#include "armv7-m.dtsi"
+#include "vfxxx.dtsi"
+
+&mscm {
+	interrupt-parent = <&nvic>;
+};
-- 
2.2.1


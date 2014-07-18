Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbaGROZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:25:28 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:34864 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbaGROZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:25:25 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] ARM: dts: vf610-colibri: split device tree for carrier boards
Date: Fri, 18 Jul 2014 16:25:18 +0200
Message-Id: <1405693518-28293-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Colibri VF61 is a module which needs a carrier board to actually
run. Different carrier board have different hardware support, hence
we should reflect this in the device tree files. This patch adds the
Colibri Evaluation Board, which supports almost all peripherals
defined in the Colibri standard.

Also align the compatible naming, file splitting and file naming with
the scheme which was choosen for the Tegra based modules.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/Makefile                  |   2 +-
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |  46 +++++++++++
 arch/arm/boot/dts/vf610-colibri.dts         | 123 ----------------------------
 arch/arm/boot/dts/vf610-colibri.dtsi        | 113 +++++++++++++++++++++++++
 4 files changed, 160 insertions(+), 124 deletions(-)
 create mode 100644 arch/arm/boot/dts/vf610-colibri-eval-v3.dts
 delete mode 100644 arch/arm/boot/dts/vf610-colibri.dts
 create mode 100644 arch/arm/boot/dts/vf610-colibri.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index adb5ed9..acb552c 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -216,7 +216,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
 	imx6q-udoo.dtb \
 	imx6q-wandboard.dtb \
 	imx6sl-evk.dtb \
-	vf610-colibri.dtb \
+	vf610-colibri-eval-v3.dtb \
 	vf610-cosmic.dtb \
 	vf610-twr.dtb
 dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
new file mode 100644
index 0000000..7fb3066
--- /dev/null
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2014 Toradex AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/dts-v1/;
+#include "vf610-colibri.dtsi"
+
+/ {
+	model = "Toradex Colibri VF61 on Colibri Evaluation Board";
+	compatible = "toradex,vf610-colibri_vf61-on-eval", "toradex,vf610-colibri_vf61", "fsl,vf610";
+
+	chosen {
+		bootargs = "console=ttyLP0,115200";
+	};
+};
+
+&esdhc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_esdhc1>;
+	bus-width = <4>;
+	status = "okay";
+};
+
+&fec1 {
+	phy-mode = "rmii";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_fec1>;
+	status = "okay";
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/vf610-colibri.dts b/arch/arm/boot/dts/vf610-colibri.dts
deleted file mode 100644
index aecc7db..0000000
--- a/arch/arm/boot/dts/vf610-colibri.dts
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * Copyright 2014 Toradex AG
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-/dts-v1/;
-#include "vf610.dtsi"
-
-/ {
-	model = "Toradex Colibri VF61 COM";
-	compatible = "toradex,vf610-colibri", "fsl,vf610";
-
-	chosen {
-		bootargs = "console=ttyLP0,115200";
-	};
-
-	memory {
-		reg = <0x80000000 0x10000000>;
-	};
-
-	clocks {
-		enet_ext {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <50000000>;
-		};
-	};
-
-};
-
-&esdhc1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_esdhc1>;
-	bus-width = <4>;
-	status = "okay";
-};
-
-&fec1 {
-	phy-mode = "rmii";
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_fec1>;
-	status = "okay";
-};
-
-&L2 {
-	arm,data-latency = <2 1 2>;
-	arm,tag-latency = <3 2 3>;
-};
-
-&uart0 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart0>;
-	status = "okay";
-};
-
-&uart1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart1>;
-	status = "okay";
-};
-
-&uart2 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart2>;
-	status = "okay";
-};
-
-&iomuxc {
-	vf610-colibri {
-		pinctrl_esdhc1: esdhc1grp {
-			fsl,fsl,pins = <
-				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
-				VF610_PAD_PTA25__ESDHC1_CMD	0x31ef
-				VF610_PAD_PTA26__ESDHC1_DAT0	0x31ef
-				VF610_PAD_PTA27__ESDHC1_DAT1	0x31ef
-				VF610_PAD_PTA28__ESDHC1_DATA2	0x31ef
-				VF610_PAD_PTA29__ESDHC1_DAT3	0x31ef
-				VF610_PAD_PTB20__GPIO_42	0x219d
-			>;
-		};
-
-		pinctrl_fec1: fec1grp {
-			fsl,pins = <
-				VF610_PAD_PTC9__ENET_RMII1_MDC		0x30d2
-				VF610_PAD_PTC10__ENET_RMII1_MDIO	0x30d3
-				VF610_PAD_PTC11__ENET_RMII1_CRS		0x30d1
-				VF610_PAD_PTC12__ENET_RMII_RXD1		0x30d1
-				VF610_PAD_PTC13__ENET_RMII1_RXD0	0x30d1
-				VF610_PAD_PTC14__ENET_RMII1_RXER	0x30d1
-				VF610_PAD_PTC15__ENET_RMII1_TXD1	0x30d2
-				VF610_PAD_PTC16__ENET_RMII1_TXD0	0x30d2
-				VF610_PAD_PTC17__ENET_RMII1_TXEN	0x30d2
-			>;
-		};
-
-		pinctrl_uart0: uart0grp {
-			fsl,pins = <
-				VF610_PAD_PTB10__UART0_TX		0x21a2
-				VF610_PAD_PTB11__UART0_RX		0x21a1
-			>;
-		};
-
-		pinctrl_uart1: uart1grp {
-			fsl,pins = <
-				VF610_PAD_PTB4__UART1_TX		0x21a2
-				VF610_PAD_PTB5__UART1_RX		0x21a1
-			>;
-		};
-
-		pinctrl_uart2: uart2grp {
-			fsl,pins = <
-				VF610_PAD_PTD0__UART2_TX		0x21a2
-				VF610_PAD_PTD1__UART2_RX		0x21a1
-				VF610_PAD_PTD2__UART2_RTS		0x21a2
-				VF610_PAD_PTD3__UART2_CTS		0x21a1
-			>;
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
new file mode 100644
index 0000000..e595c29
--- /dev/null
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -0,0 +1,113 @@
+/*
+ * Copyright 2014 Toradex AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "vf610.dtsi"
+
+/ {
+	model = "Toradex Colibri VF61 COM";
+	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
+
+	memory {
+		reg = <0x80000000 0x10000000>;
+	};
+
+	clocks {
+		enet_ext {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+};
+
+&esdhc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_esdhc1>;
+	bus-width = <4>;
+};
+
+&fec1 {
+	phy-mode = "rmii";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_fec1>;
+};
+
+&L2 {
+	arm,data-latency = <2 1 2>;
+	arm,tag-latency = <3 2 3>;
+};
+
+&uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart0>;
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1>;
+};
+
+&uart2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart2>;
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
+
+		pinctrl_fec1: fec1grp {
+			fsl,pins = <
+				VF610_PAD_PTC9__ENET_RMII1_MDC		0x30d2
+				VF610_PAD_PTC10__ENET_RMII1_MDIO	0x30d3
+				VF610_PAD_PTC11__ENET_RMII1_CRS		0x30d1
+				VF610_PAD_PTC12__ENET_RMII_RXD1		0x30d1
+				VF610_PAD_PTC13__ENET_RMII1_RXD0	0x30d1
+				VF610_PAD_PTC14__ENET_RMII1_RXER	0x30d1
+				VF610_PAD_PTC15__ENET_RMII1_TXD1	0x30d2
+				VF610_PAD_PTC16__ENET_RMII1_TXD0	0x30d2
+				VF610_PAD_PTC17__ENET_RMII1_TXEN	0x30d2
+			>;
+		};
+
+		pinctrl_uart0: uart0grp {
+			fsl,pins = <
+				VF610_PAD_PTB10__UART0_TX		0x21a2
+				VF610_PAD_PTB11__UART0_RX		0x21a1
+			>;
+		};
+
+		pinctrl_uart1: uart1grp {
+			fsl,pins = <
+				VF610_PAD_PTB4__UART1_TX		0x21a2
+				VF610_PAD_PTB5__UART1_RX		0x21a1
+			>;
+		};
+
+		pinctrl_uart2: uart2grp {
+			fsl,pins = <
+				VF610_PAD_PTD0__UART2_TX		0x21a2
+				VF610_PAD_PTD1__UART2_RX		0x21a1
+				VF610_PAD_PTD2__UART2_RTS		0x21a2
+				VF610_PAD_PTD3__UART2_CTS		0x21a1
+			>;
+		};
+	};
+};
-- 
2.0.1


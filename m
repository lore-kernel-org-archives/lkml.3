Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaJVQ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:29:49 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43379 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaJVQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:29:37 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, arnd@arndb.de
Cc: b35083@freescale.com, bpringlemeir@nbsps.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 4/4] ARM: dts: vf500-colibri: add Colibri VF50 support
Date: Wed, 22 Oct 2014 18:27:57 +0200
Message-Id: <1413995277-2844-5-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413995277-2844-1-git-send-email-stefan@agner.ch>
References: <1413995277-2844-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Colibri VF50 device tree files vf500-colibri.dtsi and
vf500-colibri-eval-v3.dts, in line with the Colibri VF61 device tree
files. However, to minimize dupplication we also add vf-colibri.dtsi
and vf-colibri-eval-v3.dtsi which contain the common device tree
nodes.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/Makefile                  |   1 +
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi   |  54 ++++++++++
 arch/arm/boot/dts/vf-colibri.dtsi           | 142 ++++++++++++++++++++++++++
 arch/arm/boot/dts/vf500-colibri-eval-v3.dts |  17 ++++
 arch/arm/boot/dts/vf500-colibri.dtsi        |  20 ++++
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |  47 +--------
 arch/arm/boot/dts/vf610-colibri.dtsi        | 149 +---------------------------
 7 files changed, 237 insertions(+), 193 deletions(-)
 create mode 100644 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
 create mode 100644 arch/arm/boot/dts/vf-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf500-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/vf500-colibri.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b51d485..b13c3d1 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -245,6 +245,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
 	imx6q-tx6q-1110.dtb \
 	imx6sl-evk.dtb \
 	imx6sx-sdb.dtb \
+	vf500-colibri-eval-v3.dtb \
 	vf610-colibri-eval-v3.dtb \
 	vf610-cosmic.dtb \
 	vf610-twr.dtb
diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
new file mode 100644
index 0000000..80e8fbc
--- /dev/null
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -0,0 +1,54 @@
+/*
+ * Copyright 2014 Toradex AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/ {
+	chosen {
+		bootargs = "console=ttyLP0,115200";
+	};
+};
+
+&bl {
+	brightness-levels = <0 4 8 16 32 64 128 255>;
+	default-brightness-level = <6>;
+	status  = "okay";
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
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
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
\ No newline at end of file
diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
new file mode 100644
index 0000000..ab40367
--- /dev/null
+++ b/arch/arm/boot/dts/vf-colibri.dtsi
@@ -0,0 +1,142 @@
+/*
+ * Copyright 2014 Toradex AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/ {
+	bl: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm0 0 5000000 0>;
+		status = "disabled";
+	};
+};
+
+&adc0 {
+	status = "okay";
+};
+
+&adc1 {
+	status = "okay";
+};
+
+&edma0 {
+	status = "okay";
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
+&pwm0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm0>;
+};
+
+&pwm1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm1>;
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
+&usbdev0 {
+	disable-over-current;
+	status = "okay";
+};
+
+&usbh1 {
+	disable-over-current;
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
+		pinctrl_pwm0: pwm0grp {
+			fsl,pins = <
+				VF610_PAD_PTB0__FTM0_CH0		0x1182
+				VF610_PAD_PTB1__FTM0_CH1		0x1182
+			>;
+		};
+
+		pinctrl_pwm1: pwm1grp {
+			fsl,pins = <
+				VF610_PAD_PTB8__FTM1_CH0		0x1182
+				VF610_PAD_PTB9__FTM1_CH1		0x1182
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
diff --git a/arch/arm/boot/dts/vf500-colibri-eval-v3.dts b/arch/arm/boot/dts/vf500-colibri-eval-v3.dts
new file mode 100644
index 0000000..7fc782c
--- /dev/null
+++ b/arch/arm/boot/dts/vf500-colibri-eval-v3.dts
@@ -0,0 +1,17 @@
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
+#include "vf500-colibri.dtsi"
+#include "vf-colibri-eval-v3.dtsi"
+
+/ {
+	model = "Toradex Colibri VF50 on Colibri Evaluation Board";
+	compatible = "toradex,vf500-colibri_vf50-on-eval", "toradex,vf500-colibri_vf50", "fsl,vf500";
+};
diff --git a/arch/arm/boot/dts/vf500-colibri.dtsi b/arch/arm/boot/dts/vf500-colibri.dtsi
new file mode 100644
index 0000000..cee34a3
--- /dev/null
+++ b/arch/arm/boot/dts/vf500-colibri.dtsi
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2014 Toradex AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "vf500.dtsi"
+#include "vf-colibri.dtsi"
+
+/ {
+	model = "Toradex Colibri VF50 COM";
+	compatible = "toradex,vf610-colibri_vf50", "fsl,vf500";
+
+	memory {
+		reg = <0x80000000 0x8000000>;
+	};
+};
diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 711cf82..10ebe99 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -9,52 +9,9 @@
 
 /dts-v1/;
 #include "vf610-colibri.dtsi"
+#include "vf-colibri-eval-v3.dtsi"
 
 / {
 	model = "Toradex Colibri VF61 on Colibri Evaluation Board";
 	compatible = "toradex,vf610-colibri_vf61-on-eval", "toradex,vf610-colibri_vf61", "fsl,vf610";
-
-	chosen {
-		bootargs = "console=ttyLP0,115200";
-	};
-};
-
-&bl {
-	brightness-levels = <0 4 8 16 32 64 128 255>;
-	default-brightness-level = <6>;
-	status  = "okay";
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
-&pwm0 {
-	status = "okay";
-};
-
-&pwm1 {
-	status = "okay";
-};
-
-&uart0 {
-	status = "okay";
-};
-
-&uart1 {
-	status = "okay";
-};
-
-&uart2 {
-	status = "okay";
-};
+};
\ No newline at end of file
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 2bcee5a..19fe045 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -8,6 +8,7 @@
  */
 
 #include "vf610.dtsi"
+#include "vf-colibri.dtsi"
 
 / {
 	model = "Toradex Colibri VF61 COM";
@@ -16,157 +17,9 @@
 	memory {
 		reg = <0x80000000 0x10000000>;
 	};
-
-	clocks {
-		enet_ext {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <50000000>;
-		};
-	};
-
-	bl: backlight {
-		compatible = "pwm-backlight";
-		pwms = <&pwm0 0 5000000 0>;
-		status = "disabled";
-	};
-};
-
-&adc0 {
-	status = "okay";
-};
-
-&adc1 {
-	status = "okay";
-};
-
-&edma0 {
-	status = "okay";
-};
-
-&esdhc1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_esdhc1>;
-	bus-width = <4>;
-};
-
-&fec1 {
-	phy-mode = "rmii";
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_fec1>;
 };
 
 &L2 {
 	arm,data-latency = <2 1 2>;
 	arm,tag-latency = <3 2 3>;
 };
-
-&pwm0 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_pwm0>;
-};
-
-&pwm1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_pwm1>;
-};
-
-&uart0 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart0>;
-};
-
-&uart1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart1>;
-};
-
-&uart2 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart2>;
-};
-
-&usbdev0 {
-	disable-over-current;
-	status = "okay";
-};
-
-&usbh1 {
-	disable-over-current;
-	status = "okay";
-};
-
-&usbphy0 {
-	status = "okay";
-};
-
-&usbphy1 {
-	status = "okay";
-};
-
-&iomuxc {
-	vf610-colibri {
-		pinctrl_esdhc1: esdhc1grp {
-			fsl,pins = <
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
-		pinctrl_pwm0: pwm0grp {
-			fsl,pins = <
-				VF610_PAD_PTB0__FTM0_CH0		0x1182
-				VF610_PAD_PTB1__FTM0_CH1		0x1182
-			>;
-		};
-
-		pinctrl_pwm1: pwm1grp {
-			fsl,pins = <
-				VF610_PAD_PTB8__FTM1_CH0		0x1182
-				VF610_PAD_PTB9__FTM1_CH1		0x1182
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
-- 
2.1.2


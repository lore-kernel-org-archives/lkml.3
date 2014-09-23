Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaIWRjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:39:12 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:50319 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaIWRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:38:19 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com, stefan@agner.ch
Subject: [PATCH v2 4/5] ARM: dts: vf610: use new GPIO support
Date: Tue, 23 Sep 2014 19:37:56 +0200
Message-Id: <b3cc02fe58757a4181119149900a1aef92a37058.1411492954.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411492954.git.stefan@agner.ch>
References: <cover.1411492954.git.stefan@agner.ch>
In-Reply-To: <cover.1411492954.git.stefan@agner.ch>
References: <cover.1411492954.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GPIO support by adding SD card detection configuration and
GPIO pinmux for Colibri's standard GPIO pins. Attach the GPIO
pins to the iomuxc node to get the GPIO pin settings applied.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |  5 +++++
 arch/arm/boot/dts/vf610-colibri.dtsi        | 19 +++++++++++++++++++
 arch/arm/boot/dts/vf610-twr.dts             |  1 +
 arch/arm/boot/dts/vf610.dtsi                |  1 +
 4 files changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 7fb3066..9a0e304 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -33,6 +33,11 @@
 	status = "okay";
 };
 
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpio_ext0 &pinctrl_gpio_ext1 &pinctrl_gpio_ext2>;
+};
+
 &uart0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..c940e14 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -31,6 +31,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
 	bus-width = <4>;
+	cd-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
 };
 
 &fec1 {
@@ -71,6 +72,24 @@
 
 &iomuxc {
 	vf610-colibri {
+		pinctrl_gpio_ext0: gpio_ext0 {
+			fsl,pins = <
+				VF610_PAD_PTD10__GPIO_89	0x219d
+			>;
+		};
+
+		pinctrl_gpio_ext1: gpio_ext1 {
+			fsl,pins = <
+				VF610_PAD_PTD9__GPIO_88		0x219d
+			>;
+		};
+
+		pinctrl_gpio_ext2: gpio_ext2 {
+			fsl,pins = <
+				VF610_PAD_PTD26__GPIO_68	0x219d
+			>;
+		};
+
 		pinctrl_esdhc1: esdhc1grp {
 			fsl,pins = <
 				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 189b697..3fe8a8f 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -116,6 +116,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
 	bus-width = <4>;
+	cd-gpios = <&gpio5 6 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 4d2ec32..467c97e 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -11,6 +11,7 @@
 #include "vf610-pinfunc.h"
 #include <dt-bindings/clock/vf610-clock.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	aliases {
-- 
2.1.0


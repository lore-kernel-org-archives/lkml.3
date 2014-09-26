Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaIZL5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:57:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:47708 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaIZL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:57:20 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, shawn.guo@freescale.com
Cc: gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpringlemeir@nbsps.com, l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v4 3/4] ARM: dts: vf610: use new GPIO support
Date: Fri, 26 Sep 2014 13:57:10 +0200
Message-Id: <1e927f9a2c10d80a33f7622233fc308b420ef2bf.1411731755.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GPIO support by adding SD card detection configuration and
GPIO pinmux for Colibri's standard GPIO pins. Attach the GPIO
pins to the iomuxc node to get the GPIO pin settings applied.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610-colibri.dts | 9 +++++++++
 arch/arm/boot/dts/vf610-twr.dts     | 1 +
 arch/arm/boot/dts/vf610.dtsi        | 1 +
 3 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri.dts b/arch/arm/boot/dts/vf610-colibri.dts
index aecc7db..0599daf 100644
--- a/arch/arm/boot/dts/vf610-colibri.dts
+++ b/arch/arm/boot/dts/vf610-colibri.dts
@@ -36,6 +36,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
 	bus-width = <4>;
+	cd-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
@@ -71,6 +72,14 @@
 
 &iomuxc {
 	vf610-colibri {
+		pinctrl_gpio_ext: gpio_ext {
+			fsl,pins = <
+				VF610_PAD_PTD10__GPIO_89	0x22ed /* EXT_IO_0 */
+				VF610_PAD_PTD9__GPIO_88		0x22ed /* EXT_IO_1 */
+				VF610_PAD_PTD26__GPIO_68	0x22ed /* EXT_IO_2 */
+			>;
+		};
+
 		pinctrl_esdhc1: esdhc1grp {
 			fsl,fsl,pins = <
 				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index b8a5e8c..d0c9a09 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -117,6 +117,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
 	bus-width = <4>;
+	cd-gpios = <&gpio5 6 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 583dd36..22cf7aa2 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaIVRLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:11:30 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58163 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaIVRJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:42 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 4/9] ARM: dts: vf610-colibri: GPIO power key
Date: Mon, 22 Sep 2014 19:09:25 +0200
Message-Id: <2c2c603ecaae889c93cea081fd6b1f015fa6cf3a.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable GPIO power key on pad 41 which is routed to our default
wakeup pin SO-DIMM 45.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 7fb3066..e707243 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -8,6 +8,7 @@
  */
 
 /dts-v1/;
+#include <dt-bindings/input/input.h>
 #include "vf610-colibri.dtsi"
 
 / {
@@ -17,6 +18,20 @@
 	chosen {
 		bootargs = "console=ttyLP0,115200";
 	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpiokeys>;
+
+		power {
+			label = "Power";
+			gpios = <&gpio2 9 GPIO_ACTIVE_HIGH>;
+			linux,code = <KEY_POWER>;
+			debounce-interval = <10>;
+			gpio-key,wakeup;
+		};
+	};
 };
 
 &esdhc1 {
@@ -44,3 +59,14 @@
 &uart2 {
 	status = "okay";
 };
+
+
+&iomuxc {
+	vf610-colibri {
+		pinctrl_gpiokeys: gpiokeys {
+			fsl,pins = <
+				VF610_PAD_PTB19__GPIO_41	0x219d
+			>;
+		};
+	};
+};
-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966645Ab3DQUQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:16:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50807 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338Ab3DQUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:16:20 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCHv2] ARM:dts:omap4-panda:Update the LED support for the panda DTS
Date: Wed, 17 Apr 2013 15:16:00 -0500
Message-ID: <1366229760-4808-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
are different.

A1-A3 = gpio_wk7
ES = gpio_110

There is no change to LED D2

Abstract away the pinmux and the LED definitions for the two boards into
the respective DTS files.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   22 ++++++++++++++++++-
 arch/arm/boot/dts/omap4-panda-es.dts      |   33 +++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 03bd60d..0c48f6b 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -16,7 +16,7 @@
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
 
-	leds {
+	leds: leds {
 		compatible = "gpio-leds";
 		heartbeat {
 			label = "pandaboard::status1";
@@ -64,6 +64,7 @@
 			&mcbsp1_pins
 			&dss_hdmi_pins
 			&tpd12s015_pins
+			&led_gpio_pins
 	>;
 
 	twl6040_pins: pinmux_twl6040_pins {
@@ -135,6 +136,25 @@
 			0xf0 0x118     /* i2c4_sda PULLUP | INPUTENABLE | MODE0 */
 		>;
 	};
+
+	led_gpio_pins: pinmux_leds_pins {
+		pinctrl-single,pins = <
+		>;
+	};
+};
+
+&omap4_pmx_wkup {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&led_wkgpio_pins
+	>;
+
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1a 0x3	/* gpio_wk7 OUTPUT | MODE 3 */
+			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+		>;
+	};
 };
 
 &i2c1 {
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index f1d8c21..565d37e 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,3 +34,36 @@
 		0x5e 0x100	/* hdmi_sda.hdmi_sda INPUT | MODE 0 */
 		>;
 };
+
+&leds {
+	compatible = "gpio-leds";
+	heartbeat {
+		label = "pandaboard::status1";
+		gpios = <&gpio4 14 0>;
+		linux,default-trigger = "heartbeat";
+	};
+	mmc {
+		label = "pandaboard::status2";
+		gpios = <&gpio1 8 0>;
+		linux,default-trigger = "gpio";
+	};
+};
+
+&led_gpio_pins {
+	pinctrl-single,pins = <
+		0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
+	>;
+};
+
+&omap4_pmx_wkup {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&led_wkgpio_pins
+	>;
+
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+		>;
+	};
+};
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3EOQrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:47:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49633 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758319Ab3EOQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:47:14 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v4] ARM:dts:omap4-panda: Update the LED support for the panda DTS
Date: Wed, 15 May 2013 11:46:26 -0500
Message-ID: <1368636386-17138-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.5.4
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
 arch/arm/boot/dts/omap4-panda-common.dtsi |   16 +++++++++++-
 arch/arm/boot/dts/omap4-panda-es.dts      |   40 +++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 03bd60d..2b516af 100644
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
@@ -137,6 +137,20 @@
 	};
 };
 
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
+};
+
 &i2c1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index f1d8c21..e6f696d 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,3 +34,43 @@
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
+		linux,default-trigger = "mmc0";
+	};
+};
+
+&omap4_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&led_gpio_pins
+	>;
+
+	led_gpio_pins: gpio_led_pmx {
+		pinctrl-single,pins = <
+			0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
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
+			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+		>;
+	};
+};
-- 
1.7.5.4


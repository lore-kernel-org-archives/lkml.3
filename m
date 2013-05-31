Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3EaPpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:45:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45989 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3EaPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:45:27 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v10 1/2] ARM: dts: omap4-panda: Update the LED support for the panda DTS
Date: Fri, 31 May 2013 10:44:55 -0500
Message-ID: <1370015095-26746-1-git-send-email-dmurphy@ti.com>
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
v10 - Update gpio entries to use gpio macros - https://patchwork.kernel.org/patch/2644561/ 
v9 - Removed comments for mux config - https://patchwork.kernel.org/patch/2644391/
v8 - Rebase to latest and use pinctrl macros - https://patchwork.kernel.org/patch/2629351/
v7 - Update headline to add spaces - https://patchwork.kernel.org/patch/2583661/
v6 - Review comments updated - https://patchwork.kernel.org/patch/2582771/
v5 - Provide pincrtl phandle to the gpio-led driver - https://patchwork.kernel.org/patch/2573981/
 arch/arm/boot/dts/omap4-panda-common.dtsi |   16 +++++++++++++++-
 arch/arm/boot/dts/omap4-panda-es.dts      |   28 ++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index d5d144a..800fa4e 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -16,8 +16,13 @@
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
 
-	leds {
+	leds: leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&led_wkgpio_pins
+		>;
+
 		heartbeat {
 			label = "pandaboard::status1";
 			gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
@@ -157,6 +162,15 @@
 	};
 };
 
+&omap4_pmx_wkup {
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1a (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk7 */
+			0x1c (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk8 */
+		>;
+	};
+};
+
 &i2c1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 5cfdf19..56c4354 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,3 +34,31 @@
 		0x5e (PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
 		>;
 };
+
+&omap4_pmx_core {
+	led_gpio_pins: gpio_led_pmx {
+		pinctrl-single,pins = <
+			0xb6 (PIN_OUTPUT | MUX_MODE3)	/* gpio_110 */
+		>;
+	};
+};
+
+&led_wkgpio_pins {
+	pinctrl-single,pins = <
+		0x1c (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk8 */
+	>;
+};
+
+&leds {
+	pinctrl-0 = <
+		&led_gpio_pins
+		&led_wkgpio_pins
+	>;
+
+	heartbeat {
+		gpios = <&gpio4 14 GPIO_ACTIVE_HIGH>;
+	};
+	mmc {
+		gpios = <&gpio1 8 GPIO_ACTIVE_HIGH>;
+	};
+};
-- 
1.7.5.4


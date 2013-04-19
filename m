Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3DSJ6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:58:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45945 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875Ab3DSJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:57:52 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <paul@pwsan.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 3/4] ARM: dts: omap3-beagle-xm: Add USB Host support
Date: Fri, 19 Apr 2013 12:57:36 +0300
Message-ID: <1366365457-28972-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366365457-28972-1-git-send-email-rogerq@ti.com>
References: <1366365457-28972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide RESET and Power regulators for the USB PHY,
the USB Host port mode and the PHY device.

Also provide pin multiplexer information for USB host
pins.

CC: Benoît Cousson <b-cousson@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts |   61 +++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 5a31964..19a8ccb 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -57,6 +57,59 @@
 		ti,mcbsp = <&mcbsp2>;
 		ti,codec = <&twl_audio>;
 	};
+
+	/* HS USB Port 2 RESET */
+	hsusb2_reset: hsusb2_reset_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb2_reset";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio5 19 0>;	/* gpio_147 */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
+
+	/* HS USB Port 2 Power */
+	hsusb2_power: hsusb2_power_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb2_vbus";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&twl_gpio 18 0>;	/* GPIO LEDA */
+		startup-delay-us = <70000>;
+	};
+
+	/* HS USB Host PHY on PORT 2 */
+	hsusb2_phy: hsusb2_phy {
+		compatible = "usb-nop-xceiv";
+		reset-supply = <&hsusb2_reset>;
+		vcc-supply = <&hsusb2_power>;
+	};
+
+};
+
+&omap3_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusbb2_pins
+	>;
+
+	hsusbb2_pins: pinmux_hsusbb2_pins {
+		pinctrl-single,pins = <
+			0x5c0 0x3	/* etk_d10.hsusb2_clk OUTPUT | MODE3 */
+			0x5c2 0x3	/* etk_d11.hsusb2_stp OUTPUT | MODE3 */
+			0x5c4 0x10b	/* etk_d12.hsusb2_dir INPUT_PULLDOWN | MODE3 */
+			0x5c6 0x10b	/* etk_d13.hsusb2_nxt INPUT_PULLDOWN | MODE3 */
+			0x5c8 0x10b	/* etk_d14.hsusb2_data0 INPUT_PULLDOWN | MODE3*/
+			0x5cA 0x10b	/* etk_d15.hsusb2_data1 INPUT_PULLDOWN | MODE3 */
+			0x1a4 0x10b	/* mcspi1_cs3.hsusb2_data2 INPUT_PULLDOWN | MODE3 */
+			0x1a6 0x10b	/* mcspi2_cs1.hsusb2_data3 INPUT_PULLDOWN | MODE3 */
+			0x1a8 0x10b	/* mcspi2_simo.hsusb2_data4 INPUT_PULLDOWN | MODE3 */
+			0x1aa 0x10b	/* mcspi2_somi.hsusb2_data5 INPUT_PULLDOWN | MODE3 */
+			0x1ac 0x10b	/* mcspi2_cs0.hsusb2_data6 INPUT_PULLDOWN | MODE3 */
+			0x1ae 0x10b	/* mcspi2_clk.hsusb2_data7 INPUT_PULLDOWN | MODE3 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -125,3 +178,11 @@
 	mode = <3>;
 	power = <50>;
 };
+
+&usbhshost {
+	port2-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <0 &hsusb2_phy>;
+};
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab3DSJ7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:59:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab3DSJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:57:48 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <paul@pwsan.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 1/4] ARM: dts: omap4-panda: Add USB Host support
Date: Fri, 19 Apr 2013 12:57:34 +0300
Message-ID: <1366365457-28972-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366365457-28972-1-git-send-email-rogerq@ti.com>
References: <1366365457-28972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the RESET and Power regulators for the USB PHY,
the USB Host port mode and the PHY device.

The USB PHY needs AUXCLK3 to operate. Provide this information
as well.

Also provide pin multiplexer information for the USB host
pins.

CC: Benoît Cousson <b-cousson@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   58 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap4.dtsi              |    5 ++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 03bd60d..52b8d89 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -54,6 +54,38 @@
 			"AFML", "Line In",
 			"AFMR", "Line In";
 	};
+
+	/* HS USB Port 1 RESET */
+	hsusb1_reset: hsusb1_reset_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb1_reset";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio2 30 0>;	/* gpio_62 */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
+
+	/* HS USB Port 1 Power */
+	hsusb1_power: hsusb1_power_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb1_vbus";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio1 1 0>;	/* gpio_1 */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
+
+	/* HS USB Host PHY on PORT 1 */
+	hsusb1_phy: hsusb1_phy {
+		compatible = "usb-nop-xceiv";
+		reset-supply = <&hsusb1_reset>;
+		vcc-supply = <&hsusb1_power>;
+		clocks = <&auxclk3>;
+		clock-names = "main_clk";
+		clock-frequency = <19200000>;
+	};
 };
 
 &omap4_pmx_core {
@@ -64,6 +96,7 @@
 			&mcbsp1_pins
 			&dss_hdmi_pins
 			&tpd12s015_pins
+			&hsusbb1_pins
 	>;
 
 	twl6040_pins: pinmux_twl6040_pins {
@@ -108,6 +141,23 @@
 		>;
 	};
 
+	hsusbb1_pins: pinmux_hsusbb1_pins {
+		pinctrl-single,pins = <
+			0x82 0x10c	/* usbb1_ulpitll_clk.usbb1_ulpiphy_clk INPUT_PULLDOWN | MODE4 */
+			0x84 0x4	/* usbb1_ulpitll_stp.usbb1_ulpiphy_stp OUTPUT | MODE4 */
+			0x86 0x10c	/* usbb1_ulpitll_dir.usbb1_ulpiphy_dir INPUT_PULLDOWN | MODE4 */
+			0x88 0x10c	/* usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt INPUT_PULLDOWN | MODE4 */
+			0x8a 0x10c	/* usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0 INPUT_PULLDOWN | MODE4 */
+			0x8c 0x10c	/* usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1 INPUT_PULLDOWN | MODE4 */
+			0x8e 0x10c	/* usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2 INPUT_PULLDOWN | MODE4 */
+			0x90 0x10c	/* usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3 INPUT_PULLDOWN | MODE4 */
+			0x92 0x10c	/* usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4 INPUT_PULLDOWN | MODE4 */
+			0x94 0x10c	/* usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5 INPUT_PULLDOWN | MODE4 */
+			0x96 0x10c	/* usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6 INPUT_PULLDOWN | MODE4 */
+			0x98 0x10c	/* usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7 INPUT_PULLDOWN | MODE4 */
+		>;
+	};
+
 	i2c1_pins: pinmux_i2c1_pins {
 		pinctrl-single,pins = <
 			0xe2 0x118        /* i2c1_scl PULLUP | INPUTENABLE | MODE0 */
@@ -249,3 +299,11 @@
 	mode = <3>;
 	power = <50>;
 };
+
+&usbhshost {
+	port1-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <&hsusb1_phy>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 2a56428..bd6036e 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -660,5 +660,10 @@
 			ram-bits = <12>;
 			ti,has-mailbox;
 		};
+
+		auxclk3: auxclk3 {
+			#clock-cells = <0>;
+			compatible = "ti,omap-clock";
+		};
 	};
 };
-- 
1.7.4.1


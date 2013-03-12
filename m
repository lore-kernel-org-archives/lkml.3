Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3CLLqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:46:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab3CLLoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:19 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 20/24] ARM: dts: omap4-panda: Add USB Host support
Date: Tue, 12 Mar 2013 13:43:22 +0200
Message-ID: <1363088606-2692-21-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the RESET and Power regulators for the USB PHY,
the USB Host port mode and the PHY device.

Also provide pin multiplexer information for the USB host
pins.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |   56 +++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 4122efe..cfc7683 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -57,6 +57,36 @@
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
+		clock-frequency = <19200000>;
+	};
 };
 
 &omap4_pmx_core {
@@ -67,6 +97,7 @@
 			&mcbsp1_pins
 			&dss_hdmi_pins
 			&tpd12s015_pins
+			&hsusbb1_pins
 	>;
 
 	twl6040_pins: pinmux_twl6040_pins {
@@ -110,6 +141,23 @@
 			0x58 0x10b	/* hdmi_hpd.gpio_63 INPUT PULLDOWN | MODE3 */
 		>;
 	};
+
+	hsusbb1_pins: pinmux_hsusbb1_pins {
+		pinctrl-single,pins = <
+			0x82 0x10C	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_clk INPUT | PULLDOWN */
+			0x84 0x4	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_stp OUTPUT */
+			0x86 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dir INPUT | PULLDOWN */
+			0x88 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_nxt INPUT | PULLDOWN */
+			0x8a 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat0 INPUT | PULLDOWN */
+			0x8c 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat1 INPUT | PULLDOWN */
+			0x8e 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat2 INPUT | PULLDOWN */
+			0x90 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat3 INPUT | PULLDOWN */
+			0x92 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat4 INPUT | PULLDOWN */
+			0x94 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat5 INPUT | PULLDOWN */
+			0x96 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat6 INPUT | PULLDOWN */
+			0x98 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat7 INPUT | PULLDOWN */
+		>;
+	    };
 };
 
 &i2c1 {
@@ -206,3 +254,11 @@
 &twl_usb_comparator {
 	usb-supply = <&vusb>;
 };
+
+&usbhshost {
+	port1-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <&hsusb1_phy>;
+};
-- 
1.7.4.1


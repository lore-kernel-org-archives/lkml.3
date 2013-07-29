Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3G2O6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:58:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40891 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3G2O6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:58:42 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <jic23@cam.ac.uk>, <pmeerw@pmeerw.net>, <holler@ahsoftware.de>,
        <srinivas.pandruvada@intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH 1/2] ARM: OMAP4: Tablet: Add BMA180 sensor
Date: Mon, 29 Jul 2013 17:58:12 +0300
Message-ID: <1375109893-7917-1-git-send-email-x0199363@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

Add Bosch BMA180 acceleration sensor devicetree

Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 arch/arm/boot/dts/omap4-sdp.dts |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index c9022df..13d8279 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -170,6 +170,7 @@
 			&dss_hdmi_pins
 			&tpd12s015_pins
 			&apds9300_pins
+			&bma180_pins
 	>;
 
 	uart2_pins: pinmux_uart2_pins {
@@ -305,6 +306,12 @@
 			0x50 (PIN_INPUT | MUX_MODE3)		/* gpmc_nbe1.gpio_61 */
 		>;
 	};
+
+	bma180_pins: pinmux_bma180_pins {
+		pinctrl-single,pins = <
+		0x156 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_nbe1.gpio_178 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -405,6 +412,17 @@
 		interrupt-parent = <&gpio2>;
 		interrupts = <29 8>; /* gpio line 61, low triggered */
 	};
+
+	bma180@40 {
+		compatible = "bosch,bma180";
+		reg = <0x40>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <18 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
+		range = <2>;
+		bw = <5>;
+		mode_config = <1>;
+		fuzz = <555>;
+	};
 };
 
 &mcspi1 {
-- 
1.7.9.5


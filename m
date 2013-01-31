Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3AaGWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:22:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3AaGWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:22:22 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <santosh.shilimkar@ti.com>, <coelho@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH] arm: dts: omap4-panda: Add I2c pinctrl data
Date: Thu, 31 Jan 2013 11:53:21 +0530
Message-ID: <1359613401-29133-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 3.8-rc4 on omap4 panda results in the following error

[    0.444427] omap_i2c 48070000.i2c: did not get pins for i2c error: -19
[    0.445770] omap_i2c 48070000.i2c: bus 0 rev0.11 at 400 kHz
[    0.473937] omap_i2c 48072000.i2c: did not get pins for i2c error: -19
[    0.474670] omap_i2c 48072000.i2c: bus 1 rev0.11 at 400 kHz
[    0.474822] omap_i2c 48060000.i2c: did not get pins for i2c error: -19
[    0.476379] omap_i2c 48060000.i2c: bus 2 rev0.11 at 100 kHz
[    0.477294] omap_i2c 48350000.i2c: did not get pins for i2c error: -19
[    0.477996] omap_i2c 48350000.i2c: bus 3 rev0.11 at 400 kHz
[    0.483398] Switching to clocksource 32k_counter

This happens because omap4 panda dts file is not adapted to use i2c through
pinctrl framework. Populating i2c pinctrl data to get rid of the error.

Tested on omap4460 panda with 3.8-rc4 kernel.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reported-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |   40 +++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 4122efe..f951e6b 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -110,9 +110,40 @@
 			0x58 0x10b	/* hdmi_hpd.gpio_63 INPUT PULLDOWN | MODE3 */
 		>;
 	};
+
+	i2c1_pins: pinmux_i2c1_pins {
+		pinctrl-single,pins = <
+			0xe2 0x118        /* i2c1_scl PULLUP | INPUTENABLE | MODE0 */
+			0xe4 0x118        /* i2c1_sda PULLUP | INPUTENABLE | MODE0 */
+		>;
+	};
+
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0xe6 0x118        /* i2c2_scl PULLUP | INPUTENABLE | MODE0 */
+			0xe8 0x118        /* i2c2_sda PULLUP | INPUTENABLE | MODE0 */
+		>;
+	};
+
+	i2c3_pins: pinmux_i2c3_pins {
+		pinctrl-single,pins = <
+			0xea 0x118        /* i2c3_scl PULLUP | INPUTENABLE | MODE0 */
+			0xec 0x118     /* i2c3_sda PULLUP | INPUTENABLE | MODE0 */
+		>;
+	};
+
+	i2c4_pins: pinmux_i2c4_pins {
+		pinctrl-single,pins = <
+			0xee 0x118        /* i2c4_scl PULLUP | INPUTENABLE | MODE0 */
+			0xf0 0x118     /* i2c4_sda PULLUP | INPUTENABLE | MODE0 */
+		>;
+	};
 };
 
 &i2c1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c1_pins>;
+
 	clock-frequency = <400000>;
 
 	twl: twl@48 {
@@ -139,10 +170,16 @@
 /include/ "twl6030.dtsi"
 
 &i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+
 	clock-frequency = <400000>;
 };
 
 &i2c3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c3_pins>;
+
 	clock-frequency = <100000>;
 
 	/*
@@ -156,6 +193,9 @@
 };
 
 &i2c4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c4_pins>;
+
 	clock-frequency = <400000>;
 };
 
-- 
1.7.1


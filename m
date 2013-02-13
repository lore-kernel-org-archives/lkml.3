Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3BMJ2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:28:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45821 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3BMJ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:28:26 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <balbi@ti.com>, <santosh.shilimkar@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 1/5] arm: dts: omap4-sdp: Add I2c pinctrl data
Date: Wed, 13 Feb 2013 14:58:12 +0530
Message-ID: <1360747692-1470-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 3.8-rc6 on omap 4430sdp results in the following error

omap_i2c 48070000.i2c: did not get pins for i2c error: -19
[    1.024261] omap_i2c 48070000.i2c: bus 0 rev0.12 at 100 kHz
[    1.030181] omap_i2c 48072000.i2c: did not get pins for i2c error: -19
[    1.037384] omap_i2c 48072000.i2c: bus 1 rev0.12 at 400 kHz
[    1.043762] omap_i2c 48060000.i2c: did not get pins for i2c error: -19
[    1.050964] omap_i2c 48060000.i2c: bus 2 rev0.12 at 100 kHz
[    1.056823] omap_i2c 4807a000.i2c: did not get pins for i2c error: -19
[    1.064025] omap_i2c 4807a000.i2c: bus 3 rev0.12 at 400 kHz

This happens because omap4 dts file is not adapted to use i2c through pinctrl
framework. Populating i2c pinctrl data to get rid of the error.

Tested on omap4430 sdp with 3.8-rc6 kernel.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts |   40 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 43e5258..40a04c9 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -212,9 +212,40 @@
 			0x58 0x10b	/* hdmi_hpd.gpio_63 INPUT PULLDOWN | MODE3 */
 		>;
 	};
+
+	i2c1_pins: pinmux_i2c1_pins {
+		pinctrl-single,pins = <
+			0xe2 0x118        /* i2c1_scl PULLUP | INPUTENABLE | MODE0 */
+			0xe4 0x118       /* i2c1_sda PULLUP | INPUTENABLE | MODE0 */
+		>;
+	};
+
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+                        0xe6 0x118        /* i2c2_scl PULLUP | INPUTENABLE | MODE0 */
+                        0xe8 0x118        /* i2c2_sda PULLUP | INPUTENABLE | MODE0 */
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
@@ -253,10 +284,16 @@
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
 	clock-frequency = <400000>;
 
 	/*
@@ -279,6 +316,9 @@
 };
 
 &i2c4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c4_pins>;
+
 	clock-frequency = <400000>;
 
 	/*
-- 
1.7.1


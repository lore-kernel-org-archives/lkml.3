Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbbAZMQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:16:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37108 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbbAZMP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:15:58 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 5/7] ARM: dts: am57xx-beagle-x15: Add extcon nodes for USB
Date: Mon, 26 Jan 2015 14:15:30 +0200
Message-ID: <1422274532-9488-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422274532-9488-1-git-send-email-rogerq@ti.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this EVM, the USB cable state has to be determined via the
ID pin tied to a GPIO line. We use the gpio-usb-extcon driver
to read the ID pin and the extcon framework to forward
the USB cable state information to the USB driver so the
controller can be configured in the right mode (host/peripheral).

NOTE: the ports on this board cannot switch roles. They are
configured either host or peripheral by hardwiring the
respective ID pins.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/am57xx-beagle-x15.dts | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/am57xx-beagle-x15.dts b/arch/arm/boot/dts/am57xx-beagle-x15.dts
index 49edbda..ad1833b 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15.dts
+++ b/arch/arm/boot/dts/am57xx-beagle-x15.dts
@@ -80,6 +80,20 @@
 			default-state = "off";
 		};
 	};
+
+	extcon_usb1: extcon_usb1 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio7 25 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&extcon_usb1_pins>;
+	};
+
+	extcon_usb2: extcon_usb2 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio7 24 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&extcon_usb2_pins>;
+	};
 };
 
 &dra7_pmx_core {
@@ -164,6 +178,17 @@
 		>;
 	};
 
+	extcon_usb1_pins: extcon_usb1_pins {
+		pinctrl-single,pins = <
+			0x3ec (PIN_INPUT_PULLUP | MUX_MODE14) /* uart1_rtsn.gpio7_25 */
+		>;
+	};
+
+	extcon_usb2_pins: extcon_usb2_pins {
+		pinctrl-single,pins = <
+			0x3e8 (PIN_INPUT_PULLUP | MUX_MODE14) /* uart1_ctsn.gpio7_24 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -403,3 +428,11 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&usb1_pins>;
 };
+
+&omap_dwc3_1 {
+	extcon = <&extcon_usb1>;
+};
+
+&omap_dwc3_2 {
+	extcon = <&extcon_usb2>;
+};
-- 
2.1.0


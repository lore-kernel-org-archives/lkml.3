Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaCGNK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:10:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46377 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaCGNKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:10:02 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 8/8] dts: dra7-evm: add USB support
Date: Fri, 7 Mar 2014 15:09:11 +0200
Message-ID: <1394197751-28984-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB pinmux information and USB modes
for the first 2 USB controllers.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 5babba0..41c600b 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -93,6 +93,18 @@
 			0x24c (PIN_INPUT_SLEW | MUX_MODE0) /* uart3_txd */
 		>;
 	};
+
+	usb1_pins: pinmux_usb1_pins {
+                pinctrl-single,pins = <
+			0x280	0xc0000	/* usb1_drvvbus, SLOW_SLEW | PULLUPEN | MODE0 */
+                >;
+        };
+
+	usb2_pins: pinmux_usb2_pins {
+                pinctrl-single,pins = <
+			0x284	0xc0000 /* usb2_drvvbus, SLOW_SLEW | PULLUPEN | MODE0 */
+                >;
+        };
 };
 
 &i2c1 {
@@ -273,3 +285,15 @@
 &cpu0 {
 	cpu0-supply = <&smps123_reg>;
 };
+
+&usb1 {
+	dr_mode = "otg";
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb1_pins>;
+};
+
+&usb2 {
+	dr_mode = "otg";
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb2_pins>;
+};
-- 
1.8.3.2


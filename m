Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbbAWUr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:47:56 -0500
Received: from gn237.zone.eu ([217.146.67.237]:31447 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAWUrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:47:53 -0500
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 15:47:52 EST
From: Priit Laes <plaes@plaes.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Priit Laes <plaes@plaes.org>
Subject: [PATCH] ARM: dts: sun4i: Add initial dts for Gemei G9 tablet
Date: Fri, 23 Jan 2015 22:36:49 +0200
Message-Id: <1422045409-1251-1-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gemei G9 is an A10 based tablet, with 1G RAM, 16G NAND, 1024x768
IPS LCD display, stereo speakers, 1.3MP front camera and 5 MP
rear camera, 8000mAh battery, GT901 2+1 touchscreen, Bosch BMA250
accelerometer and RTL8188CUS USB wifi. It also has MicroSD slot,
miniHDMI, 1 x MicroUSB OTG port and 1 x MicroUSB host port and
3.5mm headphone jack.
More details are available at: http://linux-sunxi.org/Gemei_G9

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 arch/arm/boot/dts/Makefile               |   6 +-
 arch/arm/boot/dts/sun4i-a10-gemei-g9.dts | 138 +++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun4i-a10-gemei-g9.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7df26a2..a2e05fc 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -447,12 +447,14 @@ dtb-$(CONFIG_MACH_SUN4I) += \
 	sun4i-a10-ba10-tvbox.dtb \
 	sun4i-a10-chuwi-v7-cw0825.dtb \
 	sun4i-a10-cubieboard.dtb \
+	sun4i-a10-gemei-g9.dtb \
+	sun4i-a10-hackberry.dtb \
+	sun4i-a10-inet97fv2.dtb \
 	sun4i-a10-marsboard.dtb \
 	sun4i-a10-mini-xplus.dtb \
 	sun4i-a10-mk802.dtb \
 	sun4i-a10-mk802ii.dtb \
-	sun4i-a10-hackberry.dtb \
-	sun4i-a10-inet97fv2.dtb \
+	sun4i-a10-mini-xplus.dtb \
 	sun4i-a10-olinuxino-lime.dtb \
 	sun4i-a10-pcduino.dtb
 dtb-$(CONFIG_MACH_SUN5I) += \
diff --git a/arch/arm/boot/dts/sun4i-a10-gemei-g9.dts b/arch/arm/boot/dts/sun4i-a10-gemei-g9.dts
new file mode 100644
index 0000000..46700b8
--- /dev/null
+++ b/arch/arm/boot/dts/sun4i-a10-gemei-g9.dts
@@ -0,0 +1,138 @@
+/*
+ * Copyright 2015 Priit Laes
+ *
+ * Priit Laes <plaes@plaes.org>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this file; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/dts-v1/;
+#include "sun4i-a10.dtsi"
+#include "sunxi-common-regulators.dtsi"
+#include <dt-bindings/gpio/gpio.h>
+
+/ {
+    model = "Gemei G9 Tablet";
+    compatible = "gemei,g9", "allwinner,sun4i-a10";
+};
+
+/*
+ * http://linux-sunxi.org/Gemei_G9
+ *
+ * TODO:
+ *   2x cameras via CSI
+ *   AXP battery management
+ *   AXP power enable key
+ *   Keys (LRADC)
+ *   NAND
+ *   OTG
+ *   Touchscreen - gt801_2plus1 @ i2c adapter 2 @ 0x48
+ */
+
+
+&ehci0 {
+    status = "okay";
+};
+
+&ehci1 {
+    status = "okay";
+};
+
+&i2c0 {
+    pinctrl-names = "default";
+    pinctrl-0 = <&i2c0_pins_a>;
+    status = "okay";
+
+    axp209: pmic@34 {
+        compatible = "x-powers,axp209";
+        reg = <0x34>;
+        interrupts = <0>;
+
+        interrupt-controller;
+        #interrupt-cells = <1>;
+    };
+};
+
+&i2c1 {
+    pinctrl-names = "default";
+    pinctrl-0 = <&i2c1_pins_a>;
+    status = "okay";
+
+    /* Accelerometer */
+    bma250@18 {
+        compatible = "bosch,bma250";
+        reg = <0x18>;
+    };
+};
+
+&reg_usb1_vbus {
+    status = "okay";
+};
+
+&reg_usb2_vbus {
+    status = "okay";
+};
+
+&mmc0 {
+    pinctrl-names = "default";
+    pinctrl-0 = <&mmc0_pins_a>, <&mmc0_cd_pin_reference_design>;
+    vmmc-supply = <&reg_vcc3v3>;
+    bus-width = <4>;
+    cd-gpios = <&pio 7 1 GPIO_ACTIVE_HIGH>; /* PH01 */
+    cd-inverted;
+    status = "okay";
+};
+
+
+&uart0  {
+    pinctrl-names = "default";
+    pinctrl-0 = <&uart0_pins_a>;
+    status = "okay";
+};
+
+&usbphy {
+    usb1_vbus-supply = <&reg_usb1_vbus>;
+    usb2_vbus-supply = <&reg_usb2_vbus>;
+    status = "okay";
+};
-- 
2.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaHZP3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:29:39 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46947 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaHZP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:29:36 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        afaerber@suse.de, Nick Dyer <nick.dyer@itdev.co.uk>,
        Yufeng Shen <miletus@chromium.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 1/3] ARM: dts: Add Peach Pit dts entry for Atmel touchpad
Date: Tue, 26 Aug 2014 17:28:55 +0200
Message-Id: <1409066937-3574-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409066937-3574-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1409066937-3574-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

The Peach Pit board has an Atmel maXTouch trackpad device.
Add the needed Device Tree nodes to support it.

This Device Tree change is based on the Chrome OS 3.8 tree
but adapted to use the mainline Atmel maXTouch DT binding.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
[javier.martinez: added linux,gpio-keymap property and changed IRQ type]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1:
 - Change trackpad IRQ pad function from 0x0 (GPIO input) to 0xf (GPIO IRQ).
   suggested by Tomasz Figa.
 - Remove BTN_TOOL_* from "linux,gpio-keymap" property since those are set
   by input mt core if INPUT_MT_POINTER is set. Suggested by Nick Dyer.
 - Use correct values for "linux,gpio-keymap" property. Suggested by Nick Dyer.
 - Remove support for Peach Pi board since it uses a different Atmel touchpad
   that requires an Atmel object protocol  (T100) not supported by the driver.
 - Use IRQ type constants from <dt-bindings/interrupt-controller/irq.h> instead
   of magic numbers. Suggested by Andreas Farber.
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 31 ++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 228a6b1..e4f82d5 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -11,6 +11,7 @@
 /dts-v1/;
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "exynos5420.dtsi"
 
 / {
@@ -157,6 +158,29 @@
 	};
 };
 
+&hsi2c_8 {
+	status = "okay";
+	clock-frequency = <333000>;
+
+	trackpad@4b {
+		compatible="atmel,maxtouch";
+		reg=<0x4b>;
+		interrupt-parent=<&gpx1>;
+		interrupts=<1 IRQ_TYPE_EDGE_FALLING>;
+		wakeup-source;
+		pinctrl-names = "default";
+		pinctrl-0 = <&trackpad_irq>;
+		linux,gpio-keymap = < KEY_RESERVED
+				      KEY_RESERVED
+				      0		/* GPIO 0 */
+				      0		/* GPIO 1 */
+				      0		/* GPIO 2 */
+				      BTN_LEFT 	/* GPIO 3 */
+				      KEY_RESERVED
+				      KEY_RESERVED >;
+	};
+};
+
 &hsi2c_9 {
 	status = "okay";
 	clock-frequency = <400000>;
@@ -249,6 +273,13 @@
 		samsung,pin-drv = <0>;
 	};
 
+	trackpad_irq: trackpad-irq {
+		samsung,pins = "gpx1-1";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	power_key_irq: power-key-irq {
 		samsung,pins = "gpx1-2";
 		samsung,pin-function = <0>;
-- 
2.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaIJLbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:31:49 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35432 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIJLbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:31:48 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        afaerber@suse.de, Nick Dyer <nick.dyer@itdev.co.uk>,
        Yufeng Shen <miletus@chromium.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 2/3] ARM: dts: Add Peach Pi dts entry for Atmel touchpad
Date: Wed, 10 Sep 2014 13:31:30 +0200
Message-Id: <1410348691-18317-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410348691-18317-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1410348691-18317-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Peach Pi board has an Atmel maXTouch trackpad device.
Add the needed Device Tree nodes to support it.

This Device Tree change is based on the Chrome OS 3.8 tree
but adapted to use the mainline Atmel maXTouch DT binding.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v3: None, new patch.

 arch/arm/boot/dts/exynos5800-peach-pi.dts | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 88b3544..025a095 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -505,6 +505,27 @@
 	};
 };
 
+&hsi2c_8 {
+	status = "okay";
+	clock-frequency = <333000>;
+	/* Atmel mXT540S */
+	trackpad@4b {
+		compatible = "atmel,maxtouch";
+		reg = <0x4b>;
+		interrupt-parent = <&gpx1>;
+		interrupts = <1 IRQ_TYPE_EDGE_FALLING>;
+		wakeup-source;
+		pinctrl-names = "default";
+		pinctrl-0 = <&trackpad_irq>;
+		linux,gpio-keymap = <KEY_RESERVED
+				     KEY_RESERVED
+				     KEY_RESERVED	/* GPIO 0 */
+				     KEY_RESERVED	/* GPIO 1 */
+				     BTN_LEFT		/* GPIO 2 */
+				     KEY_RESERVED>;	/* GPIO 3 */
+	};
+};
+
 &hsi2c_9 {
 	status = "okay";
 	clock-frequency = <400000>;
@@ -589,6 +610,13 @@
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
2.1.0


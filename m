Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3HDKGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 06:06:07 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37250 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286Ab3HDKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 06:06:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] ARM: sun7i: Add Cubieboard2 Device Tree
Date: Sun,  4 Aug 2013 12:04:01 +0200
Message-Id: <1375610641-18807-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cubieboard2 is the successor of the first Cubieboard, and shares the
same hardware, except that the Allwinner A10 found initially has been
replaced by an Allwinner A20.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---

Hi,

This patch depends on the v3 of the patchset "ARM: sunxi: Introduce Allwinner A20
support" I sent previously.

 arch/arm/boot/dts/Makefile                  |  1 +
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts | 53 +++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 18a7374..5d0f365 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -212,6 +212,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun5i-a10s-olinuxino-micro.dtb \
 	sun5i-a13-olinuxino.dtb \
 	sun6i-a31-colombus.dtb \
+	sun7i-a20-cubieboard2.dtb \
 	sun7i-a20-olinuxino-micro.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
new file mode 100644
index 0000000..31b76f0
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -0,0 +1,53 @@
+/*
+ * Copyright 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "sun7i-a20.dtsi"
+
+/ {
+	model = "Cubietech Cubieboard2";
+	compatible = "cubietech,cubieboard2", "allwinner,sun7i-a20";
+
+	soc@01c00000 {
+		pinctrl@01c20800 {
+			led_pins_cubieboard2: led_pins@0 {
+				allwinner,pins = "PH20", "PH21";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+		};
+
+		uart0: serial@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
+			status = "okay";
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&led_pins_cubieboard2>;
+
+		blue {
+			label = "cubieboard2:blue:usr";
+			gpios = <&pio 7 21 0>;
+		};
+
+		green {
+			label = "cubieboard2:green:usr";
+			gpios = <&pio 7 20 0>;
+		};
+	};
+};
-- 
1.8.3.4


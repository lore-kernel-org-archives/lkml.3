Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3JHIYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:24:07 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:56916 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3JHIYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:24:05 -0400
From: oliver+list@schinagl.nl
To: rob.herring@calxeda.com, maxime.ripard@free-electrons.com,
        oliver@schinagl.nl, pawel.moll@arm.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Cc: devicetree@vger.kernel.org, dev@linux-sunxi.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: sunxi: dts: Add support for the cubieboard3, the CubieTruck
Date: Tue,  8 Oct 2013 10:22:32 +0200
Message-Id: <1381220552-3123-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

Cubietech introduced a new cubieboard, the CubieTruck. This board added
more output connectors and features 2 GiB of RAM and a Gigabit PHY.

Tested are are uart0 and LEDS which both work as expected.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
Changes since previous version:

* It's a cubietruck, not a cubietech
* add more whitespaces
* add proper commit log

Thanks,
Oliver

 arch/arm/boot/dts/Makefile                 |  1 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 63 ++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-cubietruck.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index cc0f1fb..171e6c7 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -232,6 +232,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun5i-a13-olinuxino.dtb \
 	sun6i-a31-colombus.dtb \
 	sun7i-a20-cubieboard2.dtb \
+	sun7i-a20-cubietruck.dtb \
 	sun7i-a20-olinuxino-micro.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
new file mode 100644
index 0000000..8a1009d
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2013 Oliver Schinagl
+ *
+ * Oliver Schinagl <oliver@schinagl.nl>
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
+	model = "Cubietech Cubietruck";
+	compatible = "cubietech,cubietruck", "allwinner,sun7i-a20";
+
+	soc@01c00000 {
+		pinctrl@01c20800 {
+			led_pins_cubietruck: led_pins@0 {
+				allwinner,pins = "PH7", "PH11", "PH20", "PH21";
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
+		pinctrl-0 = <&led_pins_cubietruck>;
+
+		blue {
+			label = "cubietruck:blue:usr";
+			gpios = <&pio 7 21 0>;
+		};
+
+		orange {
+			label = "cubietruck:orange:usr";
+			gpios = <&pio 7 20 0>;
+		};
+
+		white {
+			label = "cubietruck:white:usr";
+			gpios = <&pio 7 11 0>;
+		};
+
+		green {
+			label = "cubietruck:green:usr";
+			gpios = <&pio 7 7 0>;
+		};
+	};
+};
-- 
1.8.1.5


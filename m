Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab3FQIqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:46:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53150 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3FQIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:46:01 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2] ARM: sunxi: Add Olimex A10s-Olinuxino-micro device tree
Date: Mon, 17 Jun 2013 10:45:57 +0200
Message-Id: <1371458757-6343-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
---
 arch/arm/boot/dts/Makefile                       |  1 +
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 76 ++++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f0895c5..bae46c3 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -181,6 +181,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-cubieboard.dtb \
 	sun4i-a10-mini-xplus.dtb \
 	sun4i-a10-hackberry.dtb \
+	sun5i-a10s-olinuxino-micro.dtb \
 	sun5i-a13-olinuxino.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
diff --git a/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
new file mode 100644
index 0000000..64dc0c4
--- /dev/null
+++ b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
@@ -0,0 +1,76 @@
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
+/include/ "sun5i-a10s.dtsi"
+
+/ {
+	model = "Olimex A10s-Olinuxino Micro";
+	compatible = "olimex,a10s-olinuxino-micro", "allwinner,sun5i-a10s";
+
+	soc@01c20000 {
+		emac: ethernet@01c0b000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&emac_pins_a>;
+			phy = <&phy1>;
+			status = "okay";
+		};
+
+		mdio@01c0b080 {
+			status = "okay";
+
+			phy1: ethernet-phy@1 {
+				reg = <1>;
+			};
+		};
+
+		pinctrl@01c20800 {
+			led_pins_olinuxino: led_pins@0 {
+				allwinner,pins = "PE3";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <1>;
+				allwinner,pull = <0>;
+			};
+		};
+
+		uart0: serial@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
+			status = "okay";
+		};
+
+		uart2: serial@01c28800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart2_pins_a>;
+			status = "okay";
+		};
+
+		uart3: serial@01c28c00 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart3_pins_a>;
+			status = "okay";
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&led_pins_olinuxino>;
+
+		green {
+			label = "a10s-olinuxino-micro:green:usr";
+			gpios = <&pio 4 3 0>;
+			default-state = "on";
+		};
+	};
+};
-- 
1.8.3.1


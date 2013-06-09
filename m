Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3FIQgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:36:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56960 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3FIQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:36:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/6] ARM: sunxi: Add Olimex A10s-Olinuxino-micro device tree
Date: Sun,  9 Jun 2013 18:36:06 +0200
Message-Id: <1370795767-9769-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 75 ++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts

diff --git a/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
new file mode 100644
index 0000000..73ad65e
--- /dev/null
+++ b/arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
@@ -0,0 +1,75 @@
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
+		power {
+			gpios = <&pio 4 3 0>;
+			default-state = "on";
+		};
+	};
+};
-- 
1.8.3


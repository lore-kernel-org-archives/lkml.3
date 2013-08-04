Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3HDJ7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:38 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37176 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753706Ab3HDJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:24 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 9/9] ARM: sun7i: a20-olinuxino: Enable the user LED
Date: Sun,  4 Aug 2013 11:58:50 +0200
Message-Id: <1375610330-18185-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A20-olinuxino Micro has a LED connected to the PH2 pin. Use the
gpio-led driver to enable the control over this LED.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index 4d988df..34a6c02 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -19,6 +19,15 @@
 	compatible = "olimex,a20-olinuxino-micro", "allwinner,sun7i-a20";
 
 	soc@01c00000 {
+		pinctrl@01c20800 {
+			led_pins_olinuxino: led_pins@0 {
+				allwinner,pins = "PH2";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <1>;
+				allwinner,pull = <0>;
+			};
+		};
+
 		uart0: serial@01c28000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_pins_a>;
@@ -37,4 +46,16 @@
 			status = "okay";
 		};
 	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&led_pins_olinuxino>;
+
+		green {
+			label = "a20-olinuxino-micro:green:usr";
+			gpios = <&pio 7 2 0>;
+			default-state = "on";
+		};
+	};
 };
-- 
1.8.3.4


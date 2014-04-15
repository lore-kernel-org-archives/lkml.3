Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaDOHWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:22:37 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36246 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:32 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: [PATCH 7/7] ARM: sun7i: cubietruck: enable bluetooth module
Date: Tue, 15 Apr 2014 14:41:41 +0800
Message-Id: <1397544101-18135-8-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CubieTruck has an AMPAK AP6210 WiFi+Bluetooth module. The Bluetooth
part is a BCM20710 device connected to UART2 in the A20 SoC.

The IC requires a 32.768 KHz low power clock input for proper
auto-detection of the main clock, and an enable signal via GPIO.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index cb25d3c..767c8e1 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -61,6 +61,13 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			bt_pwr_pin_cubietruck: bt_pwr_pin@0 {
+				allwinner,pins = "PH18";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		uart0: serial@01c28000 {
@@ -69,6 +76,12 @@
 			status = "okay";
 		};
 
+		uart2: serial@01c28800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart2_pins_a>;
+			status = "okay";
+		};
+
 		i2c0: i2c@01c2ac00 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c0_pins_a>;
@@ -139,4 +152,16 @@
 	reg_usb2_vbus: usb2-vbus {
 		status = "okay";
 	};
+
+	rfkill_bt {
+		compatible = "rfkill-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&bt_pwr_pin_cubietruck>, <&clk_out_a_pins_a>;
+		clocks = <&clk_out_a>;
+		clock-frequency = <32768>;
+		gpios = <&pio 7 18 0>; /* PH18 */
+		gpio-names = "reset";
+		rfkill-name = "bt";
+		rfkill-type = <2>;
+	};
 };
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaJBInp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:43:45 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55218 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaJBIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:29 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/7] pinctrl: nomadik: force-convert to generic mux bindings
Date: Thu,  2 Oct 2014 10:40:14 +0200
Message-Id: <1412239220-22495-2-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the Nomadik pin controller and all associated device
trees to use the standard, generic mux bindings for pin controllers.
There are no such device trees deployed in the wild so this is
safe to do to set a good example.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi     | 28 ++++-----
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi | 80 +++++++++++++-------------
 arch/arm/boot/dts/ste-hrefprev60.dtsi          | 12 ++--
 arch/arm/boot/dts/ste-hrefv60plus.dtsi         |  4 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi     | 20 +++----
 arch/arm/boot/dts/ste-snowball.dts             | 12 ++--
 drivers/pinctrl/nomadik/pinctrl-nomadik.c      | 16 ++++--
 7 files changed, 88 insertions(+), 84 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi b/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
index e0799966bc25..08a7365cb929 100644
--- a/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
@@ -16,8 +16,8 @@
 			uart0 {
 				uart0_default_mux: uart0_mux {
 					default_mux {
-						ste,function = "u0";
-						ste,pins = "u0_a_1";
+						function = "u0";
+						groups = "u0_a_1";
 					};
 				};
 
@@ -49,8 +49,8 @@
 			uart2 {
 				uart2_default_mode: uart2_default {
 					default_mux {
-						ste,function = "u2";
-						ste,pins = "u2txrx_a_1";
+						function = "u2";
+						groups = "u2txrx_a_1";
 					};
 
 					default_cfg1 {
@@ -80,8 +80,8 @@
 			i2c0 {
 				i2c0_default_mux: i2c_mux {
 					default_mux {
-						ste,function = "i2c0";
-						ste,pins = "i2c0_a_1";
+						function = "i2c0";
+						groups = "i2c0_a_1";
 					};
 				};
 
@@ -103,8 +103,8 @@
 			i2c1 {
 				i2c1_default_mux: i2c_mux {
 					default_mux {
-						ste,function = "i2c1";
-						ste,pins = "i2c1_b_2";
+						function = "i2c1";
+						groups = "i2c1_b_2";
 					};
 				};
 
@@ -126,8 +126,8 @@
 			i2c2 {
 				i2c2_default_mux: i2c_mux {
 					default_mux {
-						ste,function = "i2c2";
-						ste,pins = "i2c2_b_2";
+						function = "i2c2";
+						groups = "i2c2_b_2";
 					};
 				};
 
@@ -149,8 +149,8 @@
 			i2c4 {
 				i2c4_default_mux: i2c_mux {
 					default_mux {
-						ste,function = "i2c4";
-						ste,pins = "i2c4_b_2";
+						function = "i2c4";
+						groups = "i2c4_b_2";
 					};
 				};
 
@@ -172,8 +172,8 @@
 			i2c5 {
 				i2c5_default_mux: i2c_mux {
 					default_mux {
-						ste,function = "i2c5";
-						ste,pins = "i2c5_c_2";
+						function = "i2c5";
+						groups = "i2c5_c_2";
 					};
 				};
 
diff --git a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
index addfcc7c2750..61aa87138927 100644
--- a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
@@ -18,8 +18,8 @@
 			uart0 {
 				uart0_default_mode: uart0_default {
 					default_mux {
-						ste,function = "u0";
-						ste,pins = "u0_a_1";
+						function = "u0";
+						groups = "u0_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
@@ -53,8 +53,8 @@
 			uart1 {
 				uart1_default_mode: uart1_default {
 					default_mux {
-						ste,function = "u1";
-						ste,pins = "u1rxtx_a_1";
+						function = "u1";
+						groups = "u1rxtx_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO4_AH6"; /* RXD */
@@ -83,8 +83,8 @@
 			uart2 {
 				uart2_default_mode: uart2_default {
 					default_mux {
-						ste,function = "u2";
-						ste,pins = "u2rxtx_c_1";
+						function = "u2";
+						groups = "u2rxtx_c_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO29_W2"; /* RXD */
@@ -114,8 +114,8 @@
 			i2c0 {
 				i2c0_default_mode: i2c_default {
 					default_mux {
-						ste,function = "i2c0";
-						ste,pins = "i2c0_a_1";
+						function = "i2c0";
+						groups = "i2c0_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO147_C15", "GPIO148_B16"; /* SDA/SCL */
@@ -134,8 +134,8 @@
 			i2c1 {
 				i2c1_default_mode: i2c_default {
 					default_mux {
-						ste,function = "i2c1";
-						ste,pins = "i2c1_b_2";
+						function = "i2c1";
+						groups = "i2c1_b_2";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO16_AD3", "GPIO17_AD4"; /* SDA/SCL */
@@ -154,8 +154,8 @@
 			i2c2 {
 				i2c2_default_mode: i2c_default {
 					default_mux {
-						ste,function = "i2c2";
-						ste,pins = "i2c2_b_2";
+						function = "i2c2";
+						groups = "i2c2_b_2";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO10_AF5", "GPIO11_AG4"; /* SDA/SCL */
@@ -174,8 +174,8 @@
 			i2c3 {
 				i2c3_default_mode: i2c_default {
 					default_mux {
-						ste,function = "i2c3";
-						ste,pins = "i2c3_c_2";
+						function = "i2c3";
+						groups = "i2c3_c_2";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO229_AG7", "GPIO230_AF7"; /* SDA/SCL */
@@ -198,8 +198,8 @@
 			i2c4 {
 				i2c4_default_mode: i2c_default {
 					default_mux {
-						ste,function = "i2c4";
-						ste,pins = "i2c4_b_1";
+						function = "i2c4";
+						groups = "i2c4_b_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO4_AH6", "GPIO5_AG6"; /* SDA/SCL */
@@ -219,8 +219,8 @@
 			spi2 {
 				spi2_default_mode: spi_default {
 					default_mux {
-						ste,function = "spi2";
-						ste,pins = "spi2_oc1_2";
+						function = "spi2";
+						groups = "spi2_oc1_2";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO216_AG12"; /* FRM */
@@ -281,8 +281,8 @@
 				/* This is the external SD card slot, 4 bits wide */
 				sdi0_default_mode: sdi0_default {
 					default_mux {
-						ste,function = "mc0";
-						ste,pins = "mc0_a_1";
+						function = "mc0";
+						groups = "mc0_a_1";
 					};
 					default_cfg1 {
 						ste,pins =
@@ -339,8 +339,8 @@
 				/* This is the WLAN SDIO 4 bits wide */
 				sdi1_default_mode: sdi1_default {
 					default_mux {
-						ste,function = "mc1";
-						ste,pins = "mc1_a_1";
+						function = "mc1";
+						groups = "mc1_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO208_AH16"; /* CLK */
@@ -383,8 +383,8 @@
 				/* This is the eMMC 8 bits wide, usually PoP eMMC */
 				sdi2_default_mode: sdi2_default {
 					default_mux {
-						ste,function = "mc2";
-						ste,pins = "mc2_a_1";
+						function = "mc2";
+						groups = "mc2_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO128_A5"; /* CLK */
@@ -439,8 +439,8 @@
 				/* This is the eMMC 8 bits wide, usually PCB-mounted eMMC */
 				sdi4_default_mode: sdi4_default {
 					default_mux {
-						ste,function = "mc4";
-						ste,pins = "mc4_a_1";
+						function = "mc4";
+						groups = "mc4_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO203_AE23"; /* CLK */
@@ -494,8 +494,8 @@
 			msp0 {
 				msp0_default_mode: msp0_default {
 					default_msp0_mux {
-						ste,function = "msp0";
-						ste,pins = "msp0txrx_a_1", "msp0tfstck_a_1";
+						function = "msp0";
+						groups = "msp0txrx_a_1", "msp0tfstck_a_1";
 					};
 					default_msp0_cfg {
 						ste,pins =
@@ -511,8 +511,8 @@
 			msp1 {
 				msp1_default_mode: msp1_default {
 					default_mux {
-						ste,function = "msp1";
-						ste,pins = "msp1txrx_a_1", "msp1_a_1";
+						function = "msp1";
+						groups = "msp1txrx_a_1", "msp1_a_1";
 					};
 					default_cfg1 {
 						ste,pins = "GPIO33_AF2";
@@ -533,8 +533,8 @@
 				msp2_default_mode: msp2_default {
 					/* MSP2 usually used for HDMI audio */
 					default_mux {
-						ste,function = "msp2";
-						ste,pins = "msp2_a_1";
+						function = "msp2";
+						groups = "msp2_a_1";
 					};
 					default_cfg1 {
 						ste,pins =
@@ -554,8 +554,8 @@
 			musb {
 				musb_default_mode: musb_default {
 					default_mux {
-						ste,function = "usb";
-						ste,pins = "usb_a_1";
+						function = "usb";
+						groups = "usb_a_1";
 					};
 					default_cfg1 {
 						ste,pins =
@@ -609,8 +609,8 @@
 				lcd_default_mode: lcd_default {
 					default_mux {
 						/* Mux in VSI0 and all the data lines */
-						ste,function = "lcd";
-						ste,pins =
+						function = "lcd";
+						groups =
 						"lcdvsi0_a_1", /* VSI0 for LCD */
 						"lcd_d0_d7_a_1", /* Data lines */
 						"lcd_d8_d11_a_1", /* TV-out */
@@ -636,8 +636,8 @@
 				/* SKE keys on position 2 in an 8x8 matrix */
 				ske_kpa2_default_mode: ske_kpa2_default {
 					default_mux {
-						ste,function = "kp";
-						ste,pins = "kp_a_2";
+						function = "kp";
+						groups = "kp_a_2";
 					};
 					default_cfg1 {
 						ste,pins =
@@ -696,8 +696,8 @@
 				 */
 				ske_kpaoc1_default_mode: ske_kpaoc1_default {
 					default_mux {
-						ste,function = "kp";
-						ste,pins = "kp_a_1", "kp_oc1_1";
+						function = "kp";
+						groups = "kp_a_1", "kp_oc1_1";
 					};
 					default_cfg1 {
 						ste,pins =
diff --git a/arch/arm/boot/dts/ste-hrefprev60.dtsi b/arch/arm/boot/dts/ste-hrefprev60.dtsi
index abc762e24fcb..5d8b7f8ced1b 100644
--- a/arch/arm/boot/dts/ste-hrefprev60.dtsi
+++ b/arch/arm/boot/dts/ste-hrefprev60.dtsi
@@ -79,8 +79,8 @@
 			ssp0 {
 				ssp0_hrefprev60_mode: ssp0_hrefprev60_default {
 					hrefprev60_mux {
-						ste,function = "ssp0";
-						ste,pins = "ssp0_a_1";
+						function = "ssp0";
+						groups = "ssp0_a_1";
 					};
 					hrefprev60_cfg1 {
 						ste,pins = "GPIO145_C13"; /* RXD */
@@ -93,8 +93,8 @@
 				/* This additional pin needed on early MOP500 and HREFs previous to v60 */
 				sdi0_default_mode: sdi0_default {
 					hrefprev60_mux {
-						ste,function = "mc0";
-						ste,pins = "mc0dat31dir_a_1";
+						function = "mc0";
+						groups = "mc0dat31dir_a_1";
 					};
 					hrefprev60_cfg1 {
 						ste,pins = "GPIO21_AB3"; /* DAT31DIR */
@@ -114,8 +114,8 @@
 			ipgpio {
 				 ipgpio_hrefprev60_mode: ipgpio_hrefprev60 {
 					hrefprev60_mux {
-						ste,function = "ipgpio";
-						ste,pins = "ipgpio0_c_1", "ipgpio1_c_1";
+						function = "ipgpio";
+						groups = "ipgpio0_c_1", "ipgpio1_c_1";
 					};
 					hrefprev60_cfg1 {
 						ste,pins = "GPIO6_AF6", "GPIO7_AG5";
diff --git a/arch/arm/boot/dts/ste-hrefv60plus.dtsi b/arch/arm/boot/dts/ste-hrefv60plus.dtsi
index bcc1f0c37f49..2b4104ef07de 100644
--- a/arch/arm/boot/dts/ste-hrefv60plus.dtsi
+++ b/arch/arm/boot/dts/ste-hrefv60plus.dtsi
@@ -64,8 +64,8 @@
 				 */
 				ipgpio_hrefv60_mode: ipgpio_hrefv60 {
 					hrefv60_mux {
-						ste,function = "ipgpio";
-						ste,pins = "ipgpio0_c_1", "ipgpio1_c_1", "ipgpio4_c_1";
+						function = "ipgpio";
+						groups = "ipgpio0_c_1", "ipgpio1_c_1", "ipgpio4_c_1";
 					};
 					hrefv60_cfg1 {
 						ste,pins = "GPIO6_AF6", "GPIO7_AG5";
diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index dbcf521b017f..7cedb5aba9a9 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -100,24 +100,24 @@
 		uart0 {
 			uart0_default_mux: uart0_mux {
 				u0_default_mux {
-					ste,function = "u0";
-					ste,pins = "u0_a_1";
+					function = "u0";
+					groups = "u0_a_1";
 				};
 			};
 		};
 		uart1 {
 			uart1_default_mux: uart1_mux {
 				u1_default_mux {
-					ste,function = "u1";
-					ste,pins = "u1_a_1";
+					function = "u1";
+					groups = "u1_a_1";
 				};
 			};
 		};
 		mmcsd {
 			mmcsd_default_mux: mmcsd_mux {
 				mmcsd_default_mux {
-					ste,function = "mmcsd";
-					ste,pins = "mmcsd_a_1";
+					function = "mmcsd";
+					groups = "mmcsd_a_1";
 				};
 			};
 			mmcsd_default_mode: mmcsd_default {
@@ -144,8 +144,8 @@
 		i2c0 {
 			i2c0_default_mux: i2c0_mux {
 				i2c0_default_mux {
-					ste,function = "i2c0";
-					ste,pins = "i2c0_a_1";
+					function = "i2c0";
+					groups = "i2c0_a_1";
 				};
 			};
 			i2c0_default_mode: i2c0_default {
@@ -158,8 +158,8 @@
 		i2c1 {
 			i2c1_default_mux: i2c1_mux {
 				i2c1_default_mux {
-					ste,function = "i2c1";
-					ste,pins = "i2c1_a_1";
+					function = "i2c1";
+					groups = "i2c1_a_1";
 				};
 			};
 			i2c1_default_mode: i2c1_default {
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index 4a2000c620ad..e628258c6b1a 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -405,8 +405,8 @@
 				 */
 				eth_snowball_mode: eth_snowball {
 					snowball_mux {
-						ste,function = "sm";
-						ste,pins = "sm_b_1";
+						function = "sm";
+						groups = "sm_b_1";
 					};
 					/* LAN IRQ pin */
 					snowball_cfg1 {
@@ -424,8 +424,8 @@
 			sdi0 {
 				sdi0_default_mode: sdi0_default {
 					snowball_mux {
-						ste,function = "mc0";
-						ste,pins = "mc0dat31dir_a_1";
+						function = "mc0";
+						groups = "mc0dat31dir_a_1";
 					};
 					snowball_cfg1 {
 						ste,pins = "GPIO21_AB3"; /* DAT31DIR */
@@ -437,8 +437,8 @@
 			ssp0 {
 				ssp0_snowball_mode: ssp0_snowball_default {
 					snowball_mux {
-						ste,function = "ssp0";
-						ste,pins = "ssp0_a_1";
+						function = "ssp0";
+						groups = "ssp0_a_1";
 					};
 					snowball_cfg1 {
 						ste,pins = "GPIO144_B13"; /* FRM */
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index 3c29d9187146..f7f29bd6c0ce 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1520,12 +1520,13 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned long configs = 0;
 	bool has_config = 0;
 	struct property *prop;
-	const char *group, *gpio_name;
 	struct device_node *np_config;
 
-	ret = of_property_read_string(np, "ste,function", &function);
+	ret = of_property_read_string(np, "function", &function);
 	if (ret >= 0) {
-		ret = of_property_count_strings(np, "ste,pins");
+		const char *group;
+
+		ret = of_property_count_strings(np, "groups");
 		if (ret < 0)
 			goto exit;
 
@@ -1535,7 +1536,7 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, group) {
+		of_property_for_each_string(np, "groups", prop, group) {
 			ret = nmk_dt_add_map_mux(map, reserved_maps, num_maps,
 					  group, function);
 			if (ret < 0)
@@ -1548,6 +1549,9 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	if (np_config)
 		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
 	if (has_config) {
+		const char *gpio_name;
+		const char *pin;
+
 		ret = of_property_count_strings(np, "ste,pins");
 		if (ret < 0)
 			goto exit;
@@ -1557,8 +1561,8 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, group) {
-			gpio_name = nmk_find_pin_name(pctldev, group);
+		of_property_for_each_string(np, "ste,pins", prop, pin) {
+			gpio_name = nmk_find_pin_name(pctldev, pin);
 
 			ret = nmk_dt_add_map_configs(map, reserved_maps,
 						     num_maps,
-- 
1.9.3


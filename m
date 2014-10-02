Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaJBIkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:40:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63236 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaJBIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:35 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/7] pinctrl: abx500: force-convert to generic mux bindings
Date: Thu,  2 Oct 2014 10:40:15 +0200
Message-Id: <1412239220-22495-3-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ABx500 pin controller and all associated device
trees to use the standard, generic mux bindings for pin controllers.
There are no such device trees deployed in the wild so this is
safe to do to set a good example.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-href-ab8500.dtsi   | 108 +++++++++++++++----------------
 arch/arm/boot/dts/ste-href-ab8505.dtsi   |  60 ++++++++---------
 drivers/pinctrl/nomadik/pinctrl-abx500.c |  16 +++--
 3 files changed, 94 insertions(+), 90 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-ab8500.dtsi b/arch/arm/boot/dts/ste-href-ab8500.dtsi
index 30f8601da323..8be3c471d097 100644
--- a/arch/arm/boot/dts/ste-href-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-href-ab8500.dtsi
@@ -47,8 +47,8 @@
 					gpio2 {
 						gpio2_default_mode: gpio2_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio2_a_1";
+								function = "gpio";
+								groups = "gpio2_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO2_T9";
@@ -60,8 +60,8 @@
 					gpio4 {
 						gpio4_default_mode: gpio4_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio4_a_1";
+								function = "gpio";
+								groups = "gpio4_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO4_W2";
@@ -73,8 +73,8 @@
 					gpio10 {
 						gpio10_default_mode: gpio10_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio10_d_1";
+								function = "gpio";
+								groups = "gpio10_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO10_U17";
@@ -86,8 +86,8 @@
 					gpio11 {
 						gpio11_default_mode: gpio11_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio11_d_1";
+								function = "gpio";
+								groups = "gpio11_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO11_AA18";
@@ -99,8 +99,8 @@
 					gpio12 {
 						gpio12_default_mode: gpio12_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio12_d_1";
+								function = "gpio";
+								groups = "gpio12_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO12_U16";
@@ -112,8 +112,8 @@
 					gpio13 {
 						gpio13_default_mode: gpio13_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio13_d_1";
+								function = "gpio";
+								groups = "gpio13_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO13_W17";
@@ -125,8 +125,8 @@
 					gpio16 {
 						gpio16_default_mode: gpio16_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio16_a_1";
+								function = "gpio";
+								groups = "gpio16_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO16_F15";
@@ -138,8 +138,8 @@
 					gpio24 {
 						gpio24_default_mode: gpio24_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio24_a_1";
+								function = "gpio";
+								groups = "gpio24_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO24_T14";
@@ -151,8 +151,8 @@
 					gpio25 {
 						gpio25_default_mode: gpio25_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio25_a_1";
+								function = "gpio";
+								groups = "gpio25_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO25_R16";
@@ -164,8 +164,8 @@
 					gpio36 {
 						gpio36_default_mode: gpio36_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio36_a_1";
+								function = "gpio";
+								groups = "gpio36_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO36_A17";
@@ -177,8 +177,8 @@
 					gpio37 {
 						gpio37_default_mode: gpio37_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio37_a_1";
+								function = "gpio";
+								groups = "gpio37_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO37_E15";
@@ -190,8 +190,8 @@
 					gpio38 {
 						gpio38_default_mode: gpio38_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio38_a_1";
+								function = "gpio";
+								groups = "gpio38_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO38_C17";
@@ -203,8 +203,8 @@
 					gpio39 {
 						gpio39_default_mode: gpio39_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio39_a_1";
+								function = "gpio";
+								groups = "gpio39_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO39_E16";
@@ -216,8 +216,8 @@
 					gpio42 {
 						gpio42_default_mode: gpio42_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio42_a_1";
+								function = "gpio";
+								groups = "gpio42_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO42_U2";
@@ -232,8 +232,8 @@
 					gpio26 {
 						gpio26_default_mode: gpio26_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio26_d_1";
+								function = "gpio";
+								groups = "gpio26_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO26_M16";
@@ -244,8 +244,8 @@
 					gpio35 {
 						gpio35_default_mode: gpio35_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio35_d_1";
+								function = "gpio";
+								groups = "gpio35_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO35_W15";
@@ -260,8 +260,8 @@
 					ycbcr {
 						ycbcr_default_mode: ycbcr_default {
 							default_mux {
-								ste,function = "ycbcr";
-								ste,pins = "ycbcr0123_d_1";
+								function = "ycbcr";
+								groups = "ycbcr0123_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO6_Y18",
@@ -277,8 +277,8 @@
 					pwm {
 						pwm_default_mode: pwm_default {
 							default_mux {
-								ste,function = "pwmout";
-								ste,pins = "pwmout1_d_1", "pwmout2_d_1";
+								function = "pwmout";
+								groups = "pwmout1_d_1", "pwmout2_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO14_F14",
@@ -292,8 +292,8 @@
 					adi1 {
 						adi1_default_mode: adi1_default {
 							default_mux {
-								ste,function = "adi1";
-								ste,pins = "adi1_d_1";
+								function = "adi1";
+								groups = "adi1_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO17_P5",
@@ -309,8 +309,8 @@
 					usbuicc {
 						usbuicc_default_mode: usbuicc_default {
 							default_mux {
-								ste,function = "usbuicc";
-								ste,pins = "usbuicc_d_1";
+								function = "usbuicc";
+								groups = "usbuicc_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO21_H19",
@@ -325,8 +325,8 @@
 					dmic {
 						dmic_default_mode: dmic_default {
 							default_mux {
-								ste,function = "dmic";
-								ste,pins = "dmic12_d_1",
+								function = "dmic";
+								groups = "dmic12_d_1",
 									 "dmic34_d_1",
 									 "dmic56_d_1";
 							};
@@ -345,8 +345,8 @@
 					extcpena {
 						extcpena_default_mode: extcpena_default {
 							default_mux {
-								ste,function = "extcpena";
-								ste,pins = "extcpena_d_1";
+								function = "extcpena";
+								groups = "extcpena_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO34_R17";
@@ -359,8 +359,8 @@
 					modsclsda {
 						modsclsda_default_mode: modsclsda_default {
 							default_mux {
-								ste,function = "modsclsda";
-								ste,pins = "modsclsda_d_1";
+								function = "modsclsda";
+								groups = "modsclsda_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO40_T19",
@@ -376,8 +376,8 @@
 					sysclkreq2 {
 						sysclkreq2_default_mode: sysclkreq2_default {
 							default_mux {
-								ste,function = "sysclkreq";
-								ste,pins = "sysclkreq2_d_1";
+								function = "sysclkreq";
+								groups = "sysclkreq2_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO1_T10";
@@ -387,8 +387,8 @@
 						};
 						sysclkreq2_sleep_mode: sysclkreq2_sleep {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio1_a_1";
+								function = "gpio";
+								groups = "gpio1_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO1_T10";
@@ -400,8 +400,8 @@
 					sysclkreq4 {
 						sysclkreq4_default_mode: sysclkreq4_default {
 							default_mux {
-								ste,function = "sysclkreq";
-								ste,pins = "sysclkreq4_d_1";
+								function = "sysclkreq";
+								groups = "sysclkreq4_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO3_U9";
@@ -411,8 +411,8 @@
 						};
 						sysclkreq4_sleep_mode: sysclkreq4_sleep {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio3_a_1";
+								function = "gpio";
+								groups = "gpio3_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO3_U9";
diff --git a/arch/arm/boot/dts/ste-href-ab8505.dtsi b/arch/arm/boot/dts/ste-href-ab8505.dtsi
index 6006d62086a2..112053c7aa51 100644
--- a/arch/arm/boot/dts/ste-href-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-href-ab8505.dtsi
@@ -35,8 +35,8 @@
 					gpio2 {
 						gpio2_default_mode: gpio2_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio2_a_1";
+								function = "gpio";
+								groups = "gpio2_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO2_R5";
@@ -48,8 +48,8 @@
 					gpio10 {
 						gpio10_default_mode: gpio10_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio10_d_1";
+								function = "gpio";
+								groups = "gpio10_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO10_B16";
@@ -61,8 +61,8 @@
 					gpio11 {
 						gpio11_default_mode: gpio11_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio11_d_1";
+								function = "gpio";
+								groups = "gpio11_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO11_B17";
@@ -74,8 +74,8 @@
 					gpio13 {
 						gpio13_default_mode: gpio13_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio13_d_1";
+								function = "gpio";
+								groups = "gpio13_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO13_D17";
@@ -87,8 +87,8 @@
 					gpio34 {
 						gpio34_default_mode: gpio34_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio34_a_1";
+								function = "gpio";
+								groups = "gpio34_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO34_H14";
@@ -100,8 +100,8 @@
 					gpio50 {
 						gpio50_default_mode: gpio50_default {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio50_d_1";
+								function = "gpio";
+								groups = "gpio50_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO50_L4";
@@ -114,8 +114,8 @@
 					pwm {
 						pwm_default_mode: pwm_default {
 							default_mux {
-								ste,function = "pwmout";
-								ste,pins = "pwmout1_d_1";
+								function = "pwmout";
+								groups = "pwmout1_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO14_C16";
@@ -128,8 +128,8 @@
 					adi2 {
 						adi2_default_mode: adi2_default {
 							default_mux {
-								ste,function = "adi2";
-								ste,pins = "adi2_d_1";
+								function = "adi2";
+								groups = "adi2_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO17_P2",
@@ -145,8 +145,8 @@
 					modsclsda {
 						modsclsda_default_mode: modsclsda_default {
 							default_mux {
-								ste,function = "modsclsda";
-								ste,pins = "modsclsda_d_1";
+								function = "modsclsda";
+								groups = "modsclsda_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO40_J15",
@@ -159,8 +159,8 @@
 					resethw {
 						resethw_default_mode: resethw_default {
 							default_mux {
-								ste,function = "resethw";
-								ste,pins = "resethw_d_1";
+								function = "resethw";
+								groups = "resethw_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO52_D16";
@@ -172,8 +172,8 @@
 					service {
 						service_default_mode: service_default {
 							default_mux {
-								ste,function = "service";
-								ste,pins = "service_d_1";
+								function = "service";
+								groups = "service_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO53_D15";
@@ -188,8 +188,8 @@
 					sysclkreq2 {
 						sysclkreq2_default_mode: sysclkreq2_default {
 							default_mux {
-								ste,function = "sysclkreq";
-								ste,pins = "sysclkreq2_d_1";
+								function = "sysclkreq";
+								groups = "sysclkreq2_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO1_N4";
@@ -199,8 +199,8 @@
 						};
 						sysclkreq2_sleep_mode: sysclkreq2_sleep {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio1_a_1";
+								function = "gpio";
+								groups = "gpio1_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO1_N4";
@@ -212,8 +212,8 @@
 					sysclkreq4 {
 						sysclkreq4_default_mode: sysclkreq4_default {
 							default_mux {
-								ste,function = "sysclkreq";
-								ste,pins = "sysclkreq4_d_1";
+								function = "sysclkreq";
+								groups = "sysclkreq4_d_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO3_P5";
@@ -223,8 +223,8 @@
 						};
 						sysclkreq4_sleep_mode: sysclkreq4_sleep {
 							default_mux {
-								ste,function = "gpio";
-								ste,pins = "gpio3_a_1";
+								function = "gpio";
+								groups = "gpio3_a_1";
 							};
 							default_cfg {
 								ste,pins = "GPIO3_P5";
diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index af0d417fe3fb..debeffcc2134 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -894,12 +894,13 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned int nconfigs = 0;
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
 
@@ -908,7 +909,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, group) {
+		of_property_for_each_string(np, "groups", prop, group) {
 			ret = abx500_dt_add_map_mux(map, reserved_maps,
 					num_maps, group, function);
 			if (ret < 0)
@@ -928,6 +929,9 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		has_config |= nconfigs;
 	}
 	if (has_config) {
+		const char *gpio_name;
+		const char *pin;
+
 		ret = of_property_count_strings(np, "ste,pins");
 		if (ret < 0)
 			goto exit;
@@ -938,8 +942,8 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, group) {
-			gpio_name = abx500_find_pin_name(pctldev, group);
+		of_property_for_each_string(np, "ste,pins", prop, pin) {
+			gpio_name = abx500_find_pin_name(pctldev, pin);
 
 			ret = abx500_dt_add_map_configs(map, reserved_maps,
 					num_maps, gpio_name, configs, 1);
-- 
1.9.3


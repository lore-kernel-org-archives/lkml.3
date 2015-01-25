Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbbAYMWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:22:50 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35355 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbAYMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:22:29 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 7/9] ARM: dts: sun9i: Enable USB support on A80 Optimus board
Date: Sun, 25 Jan 2015 20:22:08 +0800
Message-Id: <1422188530-1794-8-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422188530-1794-1-git-send-email-wens@csie.org>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80-optimus.dts | 60 +++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
index c4de9cb9a5f6..16d30bb3a872 100644
--- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
+++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
@@ -83,6 +83,18 @@
 	};
 };
 
+&ehci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ehci2 {
+	status = "okay";
+};
+
 &i2c3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c3_pins_a>;
@@ -94,6 +106,14 @@
 	allwinner,pull = <SUN4I_PINCTRL_PULL_UP>;
 };
 
+&ohci0 {
+	status = "okay";
+};
+
+&ohci2 {
+	status = "okay";
+};
+
 &pio {
 	led_pins_optimus: led-pins@0 {
 		allwinner,pins = "PH0", "PH1";
@@ -108,6 +128,20 @@
 		allwinner,drive = <SUN4I_PINCTRL_10_MA>;
 		allwinner,pull = <SUN4I_PINCTRL_PULL_UP>;
 	};
+
+	usb1_vbus_pin_optimus: usb1_vbus_pin@1 {
+		allwinner,pins = "PH4";
+		allwinner,function = "gpio_out";
+		allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+		allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+	};
+
+	usb3_vbus_pin_optimus: usb3_vbus_pin@1 {
+		allwinner,pins = "PH5";
+		allwinner,function = "gpio_out";
+		allwinner,drive = <SUN4I_PINCTRL_10_MA>;
+		allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
+	};
 };
 
 &mmc0 {
@@ -129,6 +163,18 @@
 	status = "okay";
 };
 
+&reg_usb1_vbus {
+	pinctrl-0 = <&usb1_vbus_pin_optimus>;
+	gpio = <&pio 7 4 GPIO_ACTIVE_HIGH>; /* PH4 */
+	status = "okay";
+};
+
+&reg_usb3_vbus {
+	pinctrl-0 = <&usb3_vbus_pin_optimus>;
+	gpio = <&pio 7 5 GPIO_ACTIVE_HIGH>; /* PH5 */
+	status = "okay";
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_pins_a>;
@@ -145,3 +191,17 @@
 	/* Enable internal pull-up */
 	allwinner,pull = <SUN4I_PINCTRL_PULL_UP>;
 };
+
+&usbphy1 {
+	vbus-supply = <&reg_usb1_vbus>;
+	status = "okay";
+};
+
+&usbphy2 {
+	status = "okay";
+};
+
+&usbphy3 {
+	vbus-supply = <&reg_usb3_vbus>;
+	status = "okay";
+};
-- 
2.1.4


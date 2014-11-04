Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKDEHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:07:55 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:48849 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaKDEH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:07:28 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 6/6] ARM: dts: sun9i: Enable USB support on A80 Optimus board
Date: Tue,  4 Nov 2014 12:07:19 +0800
Message-Id: <1415074039-16590-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415074039-16590-1-git-send-email-wens@csie.org>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
This patch does not use sunxi-common-regulators.dtsi, but adds the
regulators directly. To use the common regulators file, we would
need to use phandles and switch to preprocessor includes to support
that.

---
 arch/arm/boot/dts/sun9i-a80-optimus.dts | 72 +++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
index 506948f..31010c1 100644
--- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
+++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
@@ -59,6 +59,40 @@
 	};
 
 	soc {
+		ehci0: usb@00a00000 {
+			status = "okay";
+		};
+
+		ohci0: usb@00a00400 {
+			status = "okay";
+		};
+
+		usbphy0: phy@00a00800 {
+			vbus-supply = <&reg_usb0_vbus>;
+			status = "okay";
+		};
+
+		ehci1: usb@00a01000 {
+			status = "okay";
+		};
+
+		usbphy1: phy@00a01800 {
+			status = "okay";
+		};
+
+		ehci2: usb@00a02000 {
+			status = "okay";
+		};
+
+		ohci2: usb@00a02400 {
+			status = "okay";
+		};
+
+		usbphy2: phy@00a02800 {
+			vbus-supply = <&reg_usb2_vbus>;
+			status = "okay";
+		};
+
 		pio: pinctrl@06000800 {
 			i2c3_pins_a: i2c3@0 {
 				/* Enable internal pull-up */
@@ -76,6 +110,20 @@
 				/* Enable internal pull-up */
 				allwinner,pull = <1>;
 			};
+
+			usb0_vbus_pin_optimus: usb0_vbus_pin@1 {
+				allwinner,pins = "PH4";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			usb2_vbus_pin_optimus: usb2_vbus_pin@1 {
+				allwinner,pins = "PH5";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		uart0: serial@07000000 {
@@ -116,4 +164,28 @@
 			gpios = <&pio 7 0 0>;
 		};
 	};
+
+	reg_usb0_vbus: usb0-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb0_vbus_pin_optimus>;
+		regulator-name = "usb0-vbus";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		enable-active-high;
+		gpio = <&pio 7 4 0>; /* PH4 */
+		status = "okay";
+	};
+
+	reg_usb2_vbus: usb2-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb2_vbus_pin_optimus>;
+		regulator-name = "usb2-vbus";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		enable-active-high;
+		gpio = <&pio 7 5 0>; /* PH5 */
+		status = "okay";
+	};
 };
-- 
2.1.1


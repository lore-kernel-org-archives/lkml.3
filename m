Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaKJTDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:03:01 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45478 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaKJTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:02:58 -0500
From: Roman Byshko <rbyshko@gmail.com>
To: linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 2/5] ARM: dtsi: sunxi: add common VBUS regulator
Date: Mon, 10 Nov 2014 19:55:07 +0100
Message-Id: <d6e966ae198fa018e0f13a7cbd3e8593641f7e80.1415645258.git.rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the regulator nodes for powering USB VBUS
existed only for the two host controllers. Now the regulator
is added for USB OTG too.

Signed-off-by: Roman Byshko <rbyshko@gmail.com>
---
 arch/arm/boot/dts/sunxi-common-regulators.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
index c9c5b10..f521672 100644
--- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
+++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
@@ -21,6 +21,13 @@
 				allwinner,pull = <0>;
 			};
 
+			usb0_vbus_pin_a: usb0_vbus_pin@0 {
+				allwinner,pins = "PB9";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
 			usb1_vbus_pin_a: usb1_vbus_pin@0 {
 				allwinner,pins = "PH6";
 				allwinner,function = "gpio_out";
@@ -49,6 +56,18 @@
 		status = "disabled";
 	};
 
+	reg_usb0_vbus: usb0-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb0_vbus_pin_a>;
+		regulator-name = "usb0-vbus";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		enable-active-high;
+		gpio = <&pio 1 9 0>;
+		status = "disabled";
+	};
+
 	reg_usb1_vbus: usb1-vbus {
 		compatible = "regulator-fixed";
 		pinctrl-names = "default";
-- 
2.1.2


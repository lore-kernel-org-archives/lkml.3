Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaJ0Vna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:43:30 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48131 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJ0Vn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:43:28 -0400
From: Roman Byshko <rbyshko@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 2/5] ARM: dtsi: sunxi: add common VBUS regulator
Date: Mon, 27 Oct 2014 22:43:02 +0100
Message-Id: <210cc2a03d43e3d65b08f302b3b32663044ad94f.1414444953.git.rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414444953.git.rbyshko@gmail.com>
References: <cover.1414444953.git.rbyshko@gmail.com>
In-Reply-To: <cover.1414444953.git.rbyshko@gmail.com>
References: <cover.1414444953.git.rbyshko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the regulator nodes for powering USB VBUS
existed only for the two host controllers. Now the regulator
is added for USB OTG too.
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


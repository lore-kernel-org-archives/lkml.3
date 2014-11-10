Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaKJSzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:55:37 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:36155 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaKJSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:55:34 -0500
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
Subject: [PATCH v2 4/5] ARM: dts: sun7i: Cubietruck: override regulator pin
Date: Mon, 10 Nov 2014 19:55:09 +0100
Message-Id: <e707575fe1bb0c56fb307be5839977de5dfb8f09.1415645258.git.rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cubietruck uses different pin for the USB OTG VBUS that
is why we override the one defined in sunxi-common-regulators.dtsi

Signed-off-by: Roman Byshko <rbyshko@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index a6c1a3c..1682307 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -92,6 +92,13 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			usb0_vbus_pin_a: usb0_vbus_pin@0 {
+				allwinner,pins = "PH17";
+				allwinner,function = "gpio_out";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		pwm: pwm@01c20e00 {
@@ -185,6 +192,12 @@
 		status = "okay";
 	};
 
+	reg_usb0_vbus: usb0-vbus {
+		pinctrl-0 = <&usb0_vbus_pin_a>;
+		gpio = <&pio 7 17 0>;
+		status = "okay";
+	};
+
 	reg_usb1_vbus: usb1-vbus {
 		status = "okay";
 	};
-- 
2.1.2


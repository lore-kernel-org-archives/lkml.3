Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaGNUVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:21:36 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34912 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbaGNUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:21:00 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 5/5] arm: dts: Add gta04+b3 model bindings
Date: Mon, 14 Jul 2014 22:20:28 +0200
Message-Id: <1405369228-27197-6-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405369228-27197-1-git-send-email-marek@goldelico.com>
References: <1405369228-27197-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/Makefile           |   1 +
 arch/arm/boot/dts/omap3-gta04+b3.dts | 118 +++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04+b3.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b04a57e..e869f18 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -282,6 +282,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
 	omap3-gta04a3.dtb \
 	omap3-gta04a4.dtb \
 	omap3-gta04+b2.dtb \
+	omap3-gta04+b3.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
 	omap3-ldp.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04+b3.dts b/arch/arm/boot/dts/omap3-gta04+b3.dts
new file mode 100644
index 0000000..83446b3
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04+b3.dts
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2014 H. Nikolaus Schaller <hns@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "omap3-gta04.dtsi"
+
+/ {
+	model = "Goldelico GTA04b3/Letux 7004";
+
+	aliases {
+		display0 = &lcd_b3;
+	};
+
+	lcd_b3: lcd {
+		compatible =	"sharp,lq070y3dg3b",
+				"panel-dpi";
+		label = "lcd";
+		enable-gpios = <&gpio1 12 0>;
+
+		panel-timing {
+			clock-frequency = <33260000>;
+
+			hback-porch = <64>;
+			hactive = <800>;
+			hfront-porch = <64>;
+			hsync-len = <128>;
+
+			vback-porch = <35>;
+			vactive = <480>;
+			vfront-porch = <8>;
+			vsync-len = <2>;
+
+			hsync-active = <0>;
+			vsync-active = <0>;
+			de-active = <1>;
+			pixelclk-active = <1>;
+
+		};
+
+		port {
+			lcd_b3_in: endpoint {
+				remote-endpoint = <&dpi_out>;
+			};
+		};
+	};
+};
+
+&dss {
+	pinctrl-names = "default";
+	pinctrl-0 = < &dss_dpi_pins >;
+
+	status = "okay";
+
+	port {
+		dpi_out: endpoint {
+			remote-endpoint = <&lcd_b3_in>;
+			data-lines = <24>;
+		};
+	};
+};
+
+&spi_lcd {
+	compatible = "none";
+};
+
+&madc_battery {
+	capacity = <3900000>;
+};
+
+&i2c2 {
+	/* we have a different set of LEDs */
+	tca_gpios: tca6507@45 {
+		compatible = "ti,tca6507";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x45>;
+
+		gta04_led0: red_aux@0 {
+			label = "gta04:red:aux";
+			reg = <0x0>;
+		};
+
+		gta04_led1: green_aux@1 {
+			label = "gta04:green:aux";
+			reg = <0x1>;
+		};
+
+		gta04_led2: green_aux@2 {
+			label = "gta04:blue:aux";
+			reg = <0x2>;
+		};
+
+		gta04_led3: red_power@3 {
+			label = "gta04:red:power";
+			reg = <0x3>;
+			linux,default-trigger = "default-on";
+		};
+
+		gta04_led4: green_power@4 {
+			label = "gta04:green:power";
+			reg = <0x4>;
+		};
+
+		gta04_led5: green_power@5 {
+			label = "gta04:blue:aux";
+			reg = <0x5>;
+		};
+
+		wifi_reset: wifi_reset@6 {
+			reg = <0x6>;
+			compatible = "gpio";
+		};
+	};
+};
-- 
1.9.1


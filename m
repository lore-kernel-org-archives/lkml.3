Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbaGNUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:21:05 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44022 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaGNUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:20:57 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 4/5] arm: dts: Add gta04+b2 model bindings
Date: Mon, 14 Jul 2014 22:20:27 +0200
Message-Id: <1405369228-27197-5-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405369228-27197-1-git-send-email-marek@goldelico.com>
References: <1405369228-27197-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/Makefile           |  1 +
 arch/arm/boot/dts/omap3-gta04+b2.dts | 99 ++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04+b2.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 05aa484..b04a57e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -281,6 +281,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
 	omap3-evm-37xx.dtb \
 	omap3-gta04a3.dtb \
 	omap3-gta04a4.dtb \
+	omap3-gta04+b2.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
 	omap3-ldp.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04+b2.dts b/arch/arm/boot/dts/omap3-gta04+b2.dts
new file mode 100644
index 0000000..b68cc6e
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04+b2.dts
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2014 H. Nikolaus Schaller <marek@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "omap3-gta04.dtsi"
+
+/ {
+	model = "Goldelico GTA04b2/Letux 3704";
+
+	aliases {
+		display0 = &lcd_b2;
+	};
+
+	lcd_b2: lcd {
+		compatible =	"ortustech,com37h3m05dtc",
+				"ortustech,com37h3m099dtc",
+				"panel-dpi";
+		label = "lcd";
+		enable-gpios = <&gpio1 20 0>;
+
+		panel-timing {
+			clock-frequency = <22153000>;
+
+			hback-porch = <10>;
+			hactive = <480>;
+			hfront-porch = <8>;
+			hsync-len = <10>;
+
+			vback-porch = <4>;
+			vactive = <640>;
+			vfront-porch = <4>;
+			vsync-len = <3>;
+
+			hsync-active = <0>;
+			vsync-active = <0>;
+			de-active = <1>;
+			pixelclk-active = <1>;
+
+		};
+
+		port {
+			lcd_b2_in: endpoint {
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
+			remote-endpoint = <&lcd_b2_in>;
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
+		gta04_led3: red_power@3 {
+			label = "gta04:red:power";
+			reg = <0x3>;
+			linux,default-trigger = "default-on";
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


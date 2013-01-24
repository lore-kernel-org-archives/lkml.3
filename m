Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3AXSe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:34:28 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54750 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:34:25 -0500
From: Marek Belisko <marek.belisko@open-nandra.com>
To: b-cousson@ti.com, tony@atomide.com
Cc: linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] arm/dts: Add basic support for gta04 (Openmoko next generation) board.
Date: Thu, 24 Jan 2013 19:34:05 +0100
Message-Id: <1359052445-18560-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/boot/dts/omap3-gta04.dts |   94 +++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04.dts

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
new file mode 100644
index 0000000..9e7e3ec
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013 Marek Belisko <marek.belisko@open-nandra.com>
+ *
+ * Based on omap3-beagle-xm.dts
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "omap3.dtsi"
+
+/ {
+	model = "OMAP3 GTA04";
+	compatible = "ti,omap3-gta04", "ti,omap3";
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		aux-button {
+			label = "AUX";
+			linux,code = <169>;
+			gpios = <&gpio1 7 1>;
+			gpio-key,wakeup;
+		};
+	};
+};
+
+&i2c1 {
+	clock-frequency = <2600000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+	};
+};
+
+/include/ "twl4030.dtsi"
+
+&i2c2 {
+	clock-frequency = <400000>;
+	/* Pressure Sensor */
+	bmp085@77 {
+		compatible = "bosch,bmp085";
+		reg = <0x77>;
+	};
+
+	/* leds */
+	tca6507@45 {
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
+	};
+};
+
+&i2c3 {
+	clock-frequency = <100000>;
+};
+
+&mmc1 {
+	vmmc-supply = <&vmmc1>;
+	bus-width = <4>;
+};
+
-- 
1.7.10.4


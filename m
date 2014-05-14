Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaENOBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:01:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49635 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaENOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:01:49 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 6/8] ARM: dts: exynos5420-peach-pit: Add Vbus regulator for USB 3.0
Date: Wed, 14 May 2014 19:31:08 +0530
Message-Id: <1400076070-12456-7-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
References: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required fixed-regulator for VBUS supply for USB 3.0
controller phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts |   46 ++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index fae33dd..8402ec3 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -58,6 +58,28 @@
 		pinctrl-0 = <&pwm0_out>;
 		pinctrl-names = "default";
 	};
+
+	usb300_vbus_reg: regulator-usb300 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB3CON0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gph0 0 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb300_vbus_en>;
+		enable-active-high;
+	};
+
+	usb301_vbus_reg: regulator-usb301 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB3CON1";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gph0 1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb301_vbus_en>;
+		enable-active-high;
+	};
 };
 
 &pinctrl_0 {
@@ -76,6 +98,22 @@
 	};
 };
 
+&pinctrl_3 {
+	usb300_vbus_en: usb300-vbus-en {
+		samsung,pins = "gph0-0";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	usb301_vbus_en: usb301-vbus-en {
+		samsung,pins = "gph0-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
 &rtc {
 	status = "okay";
 };
@@ -137,6 +175,14 @@
 	};
 };
 
+&usbdrd3_0 {
+	vbus-supply = <&usb300_vbus_reg>;
+};
+
+&usbdrd3_1 {
+	vbus-supply = <&usb301_vbus_reg>;
+};
+
 /*
  * Use longest HW watchdog in SoC (32 seconds) since the hardware
  * watchdog provides no debugging information (compared to soft/hard
-- 
1.7.10.4


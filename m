Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaDWOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:36:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39869 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbaDWObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:36 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH v5 6/9] dts: exynos5420-peach-pit: Add Vbus regulator for USB 3.0
Date: Wed, 23 Apr 2014 20:00:48 +0530
Message-Id: <1398263451-18023-7-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required fixed-regulator for VBUS supply for USB 3.0
controller phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

This is first version of the patch for VBUS support for USB3DRD phy.
v5 is just and indicative of the patch-series.

 arch/arm/boot/dts/exynos5420-peach-pit.dts |   44 ++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 4d61a5e..45c0fef 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -70,6 +70,20 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		usb300_vbus_en: usb300-vbus-en {
+			samsung,pins = "gph0-0";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		usb301_vbus_en: usb301-vbus-en {
+			samsung,pins = "gph0-1";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	gpio-keys {
@@ -103,6 +117,36 @@
 		status = "okay";
 	};
 
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
+
+	phy@12100000 {
+		vbus-supply = <&usb300_vbus_reg>;
+	};
+
+	phy@12500000 {
+		vbus-supply = <&usb301_vbus_reg>;
+	};
+
 	mmc@12200000 {
 		status = "okay";
 		num-slots = <1>;
-- 
1.7.10.4


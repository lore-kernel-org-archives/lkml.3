Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaDWObj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:31:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62561 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaDWObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:31 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH v5 5/9] dts: exynos5250-snow: Add Vbus regulator for USB 3.0
Date: Wed, 23 Apr 2014 20:00:47 +0530
Message-Id: <1398263451-18023-6-git-send-email-gautam.vivek@samsung.com>
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

 arch/arm/boot/dts/exynos5250-snow.dts |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 1ce1088..fd9b3b3 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -37,6 +37,13 @@
 		sd3_bus4: sd3-bus-width4 {
 			samsung,pin-drv = <0>;
 		};
+
+		usb3_vbus_en: usb3-vbus-en {
+			samsung,pins = "gpx2-7";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	gpio-keys {
@@ -196,6 +203,21 @@
 		};
 	};
 
+	usb3_vbus_reg: regulator-usb3 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB3CON";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpx2 7 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb3_vbus_en>;
+		enable-active-high;
+	};
+
+	phy@12100000 {
+		vbus-supply = <&usb3_vbus_reg>;
+	};
+
 	usb@12110000 {
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaENOBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:01:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35566 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaENOBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:01:44 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 5/8] ARM: dts: exynos5250-snow: Add Vbus regulator for USB 3.0
Date: Wed, 14 May 2014 19:31:07 +0530
Message-Id: <1400076070-12456-6-git-send-email-gautam.vivek@samsung.com>
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


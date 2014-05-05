Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaEEMbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:31:09 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33851 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaEEMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:31:06 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        arunkk.samsung@gmail.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
Date: Mon,  5 May 2014 18:00:55 +0530
Message-Id: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos5250-snow has a SMSC USB3503 connected in
hardware only mode like a PHY. Enable support for it,
and add necessary 'reset-gpio' for it.

This is in correspondance to similar patch by Mark Brown
7c1b0ec ARM: dts: Enable USB hub on Arndale

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Based on 'for-next' branch of kgene's linux-samsung tree.

 arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
 arch/arm/boot/dts/exynos5250-snow.dts     |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 9a49e68..bd8c8f1 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -706,6 +706,13 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		usb_hub_reset: usb-hub-reset {
+			samsung,pins = "gpe1-0";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@10d10000 {
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 1ce1088..2e48f27 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -200,6 +200,20 @@
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
 
+	usb_hub_bus {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		// SMSC USB3503 connected in hardware only mode as a PHY
+		usb_hub {
+			compatible = "smsc,usb3503a";
+			reset-gpios = <&gpe1 0 1>;
+			pinctrl-0 = <&usb_hub_reset>;
+			pinctrl-names = "default";
+		};
+	};
+
 	fixed-rate-clocks {
 		xxti {
 			compatible = "samsung,clock-xxti";
-- 
1.7.10.4


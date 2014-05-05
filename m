Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaEEMbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:31:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45218 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaEEMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:31:13 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        arunkk.samsung@gmail.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 2/2] ARM: dts: Enable USB 3503 hub on exynos5420-peach-pit
Date: Mon,  5 May 2014 18:00:56 +0530
Message-Id: <1399293056-17143-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos5420-peach-pit has a SMSC USB3503 connected in
hardware only mode like a PHY. Enable support for it,
and add necessary 'reset-gpio' for it.

This is in correspondance to similar patch by Mark Brown
7c1b0ec ARM: dts: Enable USB hub on Arndale

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Based on 'for-next' branch of kgene's linux-samsung tree with
following patch:
[PATCH v4 2/2] ARM: dts: Add peach-pit board support
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29950.html

 arch/arm/boot/dts/exynos5420-peach-pit.dts |   14 ++++++++++++++
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi  |    7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index fae33dd..24c1e87 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -58,6 +58,20 @@
 		pinctrl-0 = <&pwm0_out>;
 		pinctrl-names = "default";
 	};
+
+	usb_hub_bus {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		// SMSC USB3503 connected in hardware only mode as a PHY
+		usb_hub {
+			compatible = "smsc,usb3503a";
+			reset-gpios = <&gpx2 4 1>;
+			pinctrl-0 = <&usb_hub_reset>;
+			pinctrl-names = "default";
+		};
+	};
 };
 
 &pinctrl_0 {
diff --git a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
index e62c8eb..8add143 100644
--- a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
@@ -66,6 +66,13 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		usb_hub_reset: usb-hub-reset {
+			samsung,pins = "gpx2-4";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@13410000 {
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaDHOlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:41:55 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:65290 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaDHOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:37:19 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com, gautam.vivek@samsung.com
Subject: [PATCH V4 3/5] dt: exynos5420: Enable support for DWC3 controller
Date: Tue,  8 Apr 2014 20:06:41 +0530
Message-Id: <1396967803-28868-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for DWC3 controller present on
Exynos 5420 SoC, to enable support for USB 3.0.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index a6efb52..20c2d0b 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -653,6 +653,23 @@
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
 
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 366>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12000000 0x10000>;
+			interrupts = <0 72 0>;
+			phys = <&usbdrd_phy0 0>, <&usbdrd_phy0 1>;
+			phy-names = "usb2-phy", "usb3-phy";
+		};
+	};
+
 	usbdrd_phy0: phy@12100000 {
 		compatible = "samsung,exynos5420-usbdrd-phy";
 		reg = <0x12100000 0x100>;
@@ -663,6 +680,23 @@
 		#phy-cells = <1>;
 	};
 
+	usb@12400000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 367>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12400000 0x10000>;
+			interrupts = <0 73 0>;
+			phys = <&usbdrd_phy1 0>, <&usbdrd_phy1 1>;
+			phy-names = "usb2-phy", "usb3-phy";
+		};
+	};
+
 	usbdrd_phy1: phy@12500000 {
 		compatible = "samsung,exynos5420-usbdrd-phy";
 		reg = <0x12500000 0x100>;
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaDHOhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:37:20 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59710 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaDHOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:37:12 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com, gautam.vivek@samsung.com
Subject: [PATCH v4 2/5] dt: exynos5420: Enable support for USB 3.0 PHY controller
Date: Tue,  8 Apr 2014 20:06:40 +0530
Message-Id: <1396967803-28868-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for USB 3.0 PHY present alongwith
USB 3.0 controller Exynos 5420 SoC. This phy driver is
based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 8db792b..a6efb52 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,24 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	usbdrd_phy0: phy@12100000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
+		clock-names = "phy", "ref", "usb30_sclk_100m";
+		samsung,syscon-phandle = <&pmu_system_controller>;
+		samsung,pmu-offset = <0x704>;
+		#phy-cells = <1>;
+	};
+
+	usbdrd_phy1: phy@12500000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12500000 0x100>;
+		clocks = <&clock 367>, <&clock 1>, <&clock 153>;
+		clock-names = "phy", "ref", "usb30_sclk_100m";
+		samsung,syscon-phandle = <&pmu_system_controller>;
+		samsung,pmu-offset = <0x708>;
+		#phy-cells = <1>;
+	};
 };
-- 
1.7.10.4


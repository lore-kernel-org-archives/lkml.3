Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaENOEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:04:00 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35967 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaENOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:01:26 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 1/8] ARM: dts: exynos5420: Enable support for USB 3.0 PHY controller
Date: Wed, 14 May 2014 19:31:03 +0530
Message-Id: <1400076070-12456-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
References: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for USB 3.0 PHY present alongwith
USB 3.0 controller Exynos 5420 SoC. This phy driver is
based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 6fe321b..8eebf7f 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -47,6 +47,8 @@
 		spi0 = &spi_0;
 		spi1 = &spi_1;
 		spi2 = &spi_2;
+		usbdrdphy0 = &usbdrd_phy0;
+		usbdrdphy1 = &usbdrd_phy1;
 	};
 
 	cpus {
@@ -802,4 +804,22 @@
 		samsung,sysreg-phandle = <&sysreg_system_controller>;
 		samsung,pmureg-phandle = <&pmu_system_controller>;
 	};
+
+	usbdrd_phy0: phy@12100000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock CLK_USBD300>, <&clock CLK_SCLK_USBPHY300>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <1>;
+	};
+
+	usbdrd_phy1: phy@12500000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12500000 0x100>;
+		clocks = <&clock CLK_USBD301>, <&clock CLK_SCLK_USBPHY301>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <1>;
+	};
 };
-- 
1.7.10.4


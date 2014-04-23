Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaDWObO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:31:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46729 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaDWObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:10 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH v5 1/9] dt: exynos5420: Enable support for USB 3.0 PHY controller
Date: Wed, 23 Apr 2014 20:00:43 +0530
Message-Id: <1398263451-18023-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
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
index c3a9a66..f69745f 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -732,4 +732,24 @@
 		clock-names = "secss";
 		samsung,power-domain = <&g2d_pd>;
 	};
+
+	usbdrd_phy0: phy@12100000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock CLK_USBD300>, <&clock CLK_SCLK_USBPHY300>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		samsung,pmu-offset = <0x704>;
+		#phy-cells = <1>;
+	};
+
+	usbdrd_phy1: phy@12500000 {
+		compatible = "samsung,exynos5420-usbdrd-phy";
+		reg = <0x12500000 0x100>;
+		clocks = <&clock CLK_USBD301>, <&clock CLK_SCLK_USBPHY301>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		samsung,pmu-offset = <0x708>;
+		#phy-cells = <1>;
+	};
 };
-- 
1.7.10.4


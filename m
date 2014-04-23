Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaDWOlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:41:07 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52844 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaDWObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:22 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH v5 3/9] dt: exynos5250: Enable support for generic USB DRD phy
Date: Wed, 23 Apr 2014 20:00:45 +0530
Message-Id: <1398263451-18023-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for new usbdrd-phy driver, which
is based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3742331..d4254c0 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -551,6 +551,16 @@
 		};
 	};
 
+	usbdrd_phy: phy@12100000 {
+		compatible = "samsung,exynos5250-usbdrd-phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock CLK_USB3>, <&clock CLK_FIN_PLL>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		samsung,pmu-offset = <0x704>;
+		#phy-cells = <1>;
+	};
+
 	usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
-- 
1.7.10.4


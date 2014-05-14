Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaENODl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:03:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42060 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaENOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:01:35 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 3/8] ARM: dts: exynos5250: Enable support for generic USB DRD phy
Date: Wed, 14 May 2014 19:31:05 +0530
Message-Id: <1400076070-12456-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
References: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for new usbdrd-phy driver, which
is based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 2fa6345..8303a42 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -574,6 +574,15 @@
 		};
 	};
 
+	usbdrd_phy: phy@12100000 {
+		compatible = "samsung,exynos5250-usbdrd-phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock CLK_USB3>, <&clock CLK_FIN_PLL>;
+		clock-names = "phy", "ref";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <1>;
+	};
+
 	usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
-- 
1.7.10.4


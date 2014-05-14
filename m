Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaENOBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:01:43 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63705 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaENOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:01:40 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, gregkh@linuxfoundation.org, t.figa@samsung.com,
        balbi@ti.com, kishon@ti.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 4/8] ARM: dts: exynos5250: Update DWC3 usb controller to use new phy driver
Date: Wed, 14 May 2014 19:31:06 +0530
Message-Id: <1400076070-12456-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
References: <1400076070-12456-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the dt node for older usb3 phy driver from Exynos5250
device tree and updating the dt node for DWC3 controller to
use new phy driver based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8303a42..8deadc3 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -556,21 +556,8 @@
 			compatible = "synopsys,dwc3";
 			reg = <0x12000000 0x10000>;
 			interrupts = <0 72 0>;
-			usb-phy = <&usb2_phy &usb3_phy>;
-		};
-	};
-
-	usb3_phy: usbphy@12100000 {
-		compatible = "samsung,exynos5250-usb3phy";
-		reg = <0x12100000 0x100>;
-		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_USB3>;
-		clock-names = "ext_xtal", "usbdrd30";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		usbphy-sys {
-			reg = <0x10040704 0x8>;
+			phys = <&usbdrd_phy 0>, <&usbdrd_phy 1>;
+			phy-names = "usb2-phy", "usb3-phy";
 		};
 	};
 
-- 
1.7.10.4


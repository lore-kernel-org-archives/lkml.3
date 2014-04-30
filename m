Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaD3I4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:56:13 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58255 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbaD3Izs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:55:48 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        stern@rowland.harvard.edu, kishon@ti.com, k.debski@samsung.com,
        jg1.han@samsung.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 4/4] ARM: dts: Add usb 2.0 support on exynos5420
Date: Wed, 30 Apr 2014 14:25:10 +0530
Message-Id: <1398848110-6152-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
References: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required device node for ehci and ohci controllers to
enable USB 2.0 support.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 16b860a..392d340 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -738,7 +738,41 @@
 		samsung,power-domain = <&g2d_pd>;
 	};
 
-	phy@12130000 {
+	usb@12110000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12110000 0x100>;
+		interrupts = <0 71 0>;
+
+		clocks = <&clock CLK_USBH20>;
+		clock-names = "usbhost";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phys = <&usb2_phy_gen 1>;
+			phy-names = "host";
+			status = "ok";
+		};
+	};
+
+	usb@12120000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12120000 0x100>;
+		interrupts = <0 71 0>;
+
+		clocks = <&clock CLK_USBH20>;
+		clock-names = "usbhost";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phys = <&usb2_phy_gen 1>;
+			phy-names = "host";
+			status = "ok";
+		};
+	};
+
+	usb2_phy_gen: phy@12130000 {
 		compatible = "samsung,exynos5250-usb2-phy";
 		reg = <0x12130000 0x100>;
 		clocks = <&clock CLK_USBH20>, <&clock CLK_SCLK_USBPHY300>;
-- 
1.7.10.4


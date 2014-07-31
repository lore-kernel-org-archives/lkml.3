Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaGaWts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:49:48 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:34087 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaGaWtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:49:47 -0400
From: Doug Anderson <dianders@chromium.org>
To: heiko@sntech.de, Paul Zimmerman <paulz@synopsys.com>,
        kever.yang@rock-chips.com
Cc: olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] ARM: dts: Fix the sort ordering of EHCI and HSIC in rk3288.dtsi
Date: Thu, 31 Jul 2014 15:49:35 -0700
Message-Id: <1406846976-23127-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI and HSIC device tree nodes were added in the wrong place.
Fix them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---
Changes in v4:
- Based on the proper patch

Changes in v3:
- EHCI and HSIC move new for version 3.

 arch/arm/boot/dts/rk3288.dtsi | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 9713054..49c99f2 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -156,6 +156,17 @@
 		status = "disabled";
 	};
 
+	usb_host0_ehci: usb@ff500000 {
+		compatible = "generic-ehci";
+		reg = <0xff500000 0x100>;
+		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_USBHOST0>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
+	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
+
 	usb_host1: usb@ff540000 {
 		compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
 				"snps,dwc2";
@@ -176,6 +187,15 @@
 		status = "disabled";
 	};
 
+	usb_hsic: usb@ff5c0000 {
+		compatible = "generic-ehci";
+		reg = <0xff5c0000 0x100>;
+		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_HSIC>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
 	uart2: serial@ff690000 {
 		compatible = "rockchip,rk3288-uart", "snps,dw-apb-uart";
 		reg = <0xff690000 0x100>;
@@ -270,27 +290,6 @@
 		interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
-
-	usb_host0_ehci: usb@ff500000 {
-		compatible = "generic-ehci";
-		reg = <0xff500000 0x100>;
-		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru HCLK_USBHOST0>;
-		clock-names = "usbhost";
-		status = "disabled";
-	};
-
-	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
-
-	usb_hsic: usb@ff5c0000 {
-		compatible = "generic-ehci";
-		reg = <0xff5c0000 0x100>;
-		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru HCLK_HSIC>;
-		clock-names = "usbhost";
-		status = "disabled";
-	};
-
 	gic: interrupt-controller@ffc01000 {
 		compatible = "arm,gic-400";
 		interrupt-controller;
-- 
2.0.0.526.g5318336


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaHGPNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:13:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52415 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbaHGPNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:13:49 -0400
From: Doug Anderson <dianders@chromium.org>
To: arm@kernel.org
Cc: heiko@sntech.de, Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, kever.yang@rock-chips.com,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Fix the sort ordering of EHCI and HSIC in rk3288.dtsi
Date: Thu, 07 Aug 2014 17:15:03 +0200
Message-ID: <3091007.XRV1H99NFV@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI and HSIC device tree nodes were added in the wrong place.
Fix them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/boot/dts/rk3288.dtsi | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index e7cb008..5950b0a 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -195,6 +195,26 @@
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
+	usb_hsic: usb@ff5c0000 {
+		compatible = "generic-ehci";
+		reg = <0xff5c0000 0x100>;
+		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_HSIC>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
 	i2c0: i2c@ff650000 {
 		compatible = "rockchip,rk3288-i2c";
 		reg = <0xff650000 0x1000>;
@@ -251,26 +271,6 @@
 		status = "disabled";
 	};
 
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



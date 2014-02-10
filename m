Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaBJSLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:11:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33107 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaBJSLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:11:07 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: dts: OMAP2+: Fix boot with multi_v7_defconfig
Date: Mon, 10 Feb 2014 20:10:35 +0200
Message-ID: <1392055835-6494-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP EHCI controller is not compatible with the EHCI
platform HCD driver so don't claim that we are.

This fixes boot on OMAP platforms with CONFIG_USB_EHCI_HCD_PLATFORM=y
e.g. multi_v7_defconfig

Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3.dtsi | 2 +-
 arch/arm/boot/dts/omap4.dtsi | 2 +-
 arch/arm/boot/dts/omap5.dtsi | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index a5fc83b..6b5dbf8 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -641,7 +641,7 @@
 			};
 
 			usbhsehci: ehci@48064800 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x48064800 0x400>;
 				interrupt-parent = <&intc>;
 				interrupts = <77>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d3f8a6e..f5d754b 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -706,7 +706,7 @@
 			};
 
 			usbhsehci: ehci@4a064c00 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x4a064c00 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index a72813a..42fcffd 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -784,7 +784,7 @@
 			};
 
 			usbhsehci: ehci@4a064c00 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x4a064c00 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.8.3.2


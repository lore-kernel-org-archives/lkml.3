Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3APPCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:02:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38901 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3APPCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:32 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <horms@verge.net.au>, <magnus.damm@gmail.com>, <cbou@mail.ru>,
        <dwmw2@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <leoli@freescale.com>,
        <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <stern@rowland.harvard.edu>, <kishon@ti.com>
Subject: [RFC PATCH 4/6] ARM: dts: OMAP: Add phandle to bind PHY with USB controller
Date: Wed, 16 Jan 2013 20:31:00 +0530
Message-ID: <1358348462-27693-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358348462-27693-1-git-send-email-kishon@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a phandle in the dt node for usb_otg to bind the PHY with the USB
controller and also updated the documentation with the binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
I'll add this patch in this series "usb: musb: add driver for control module"
which contains the dt data to get MUSB working in dt boot in OMAP platforms.
 Documentation/devicetree/bindings/usb/omap-usb.txt |    2 ++
 arch/arm/boot/dts/omap3.dtsi                       |    1 +
 arch/arm/boot/dts/omap4.dtsi                       |    3 ++-
 arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 3f0152b..591c4fc 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -18,6 +18,7 @@ OMAP MUSB GLUE
    represents PERIPHERAL.
  - power : Should be "50". This signifies the controller can supply upto
    100mA when operating in host mode.
+ - usb_phy : the phandle for the PHY device
 
 SOC specific device node entry
 usb_otg_hs: usb_otg_hs@4a0ab000 {
@@ -27,6 +28,7 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
 	multipoint = <1>;
 	num_eps = <16>;
 	ram_bits = <12>;
+	usb_phy = <&phy>;
 };
 
 Board specific device node entry
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 8d03736..ebbf596 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -404,6 +404,7 @@
 			interrupts = <0 92 0x4>, <0 93 0x4>;
 			interrupt-names = "mc", "dma";
 			ti,hwmods = "usb_otg_hs";
+			usb_phy = <&phy>;
 			multipoint = <1>;
 			num_eps = <16>;
 			ram_bits = <12>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 5d770be..531cb2d 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -438,7 +438,7 @@
 			#size-cells = <1>;
 			ranges;
 			ti,hwmods = "ocp2scp_usb_phy";
-			usb2phy@4a0ad080 {
+			phy: usb2phy@4a0ad080 {
 				compatible = "ti,omap-usb2";
 				reg = <0x4a0ad080 0x58>;
 			};
@@ -540,6 +540,7 @@
 			interrupts = <0 92 0x4>, <0 93 0x4>;
 			interrupt-names = "mc", "dma";
 			ti,hwmods = "usb_otg_hs";
+			usb_phy = <&phy>;
 			multipoint = <1>;
 			num_eps = <16>;
 			ram_bits = <12>;
diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index ed0bc95..80f7c2b 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -67,7 +67,7 @@
 		#interrupt-cells = <1>;
 	};
 
-	twl4030-usb {
+	phy: twl4030-usb {
 		compatible = "ti,twl4030-usb";
 		interrupts = <10>, <4>;
 		usb1v5-supply = <&vusb1v5>;
-- 
1.7.9.5


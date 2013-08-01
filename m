Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3HAOFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:05:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56933 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3HAOFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: [PATCH 7/7] ARM: dts: omap5: update omap-control-usb node
Date: Thu, 1 Aug 2013 17:05:15 +0300
Message-ID: <1375365915-21380-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split USB2 PHY and USB3 PHY into separate omap-control-usb
nodes. Update ti,mode property.

CC: Benoit Cousson <benoit.cousson@linaro.org>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 07be2cd..af8ef77 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -626,14 +626,20 @@
 			hw-caps-temp-alert;
 		};
 
-		omap_control_usb: omap-control-usb@4a002300 {
+		omap_control_usb2phy: omap-control-usb@4a002300 {
 			compatible = "ti,omap-control-usb";
-			reg = <0x4a002300 0x4>,
-			      <0x4a002370 0x4>;
-			reg-names = "control_dev_conf", "phy_power_usb";
+			reg = <0x4a002300 0x4>;
+			reg-names = "power";
 			ti,type = <2>;
 		};
 
+		omap_control_usb3phy: omap-control-usb@0x4a002370 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a002370 0x4>;
+			reg-names = "power";
+			ti,type = <3>;
+		};
+
 		omap_dwc3@4a020000 {
 			compatible = "ti,dwc3";
 			ti,hwmods = "usb_otg_ss";
@@ -661,7 +667,7 @@
 			usb2_phy: usb2phy@4a084000 {
 				compatible = "ti,omap-usb2";
 				reg = <0x4a084000 0x7c>;
-				ctrl-module = <&omap_control_usb>;
+				ctrl-module = <&omap_control_usb2phy>;
 			};
 
 			usb3_phy: usb3phy@4a084400 {
@@ -670,7 +676,7 @@
 				      <0x4a084800 0x64>,
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
-				ctrl-module = <&omap_control_usb>;
+				ctrl-module = <&omap_control_usb3phy>;
 			};
 		};
 
-- 
1.7.4.1


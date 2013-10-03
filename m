Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3JCKAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:00:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44135 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3JCKAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:00:12 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>
CC: <tony@atomide.com>, <george.cherian@ti.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <sergei.shtylyov@cogentembedded.com>,
        <thomas.langer@lantiq.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 8/8] ARM: dts: omap5: update omap-control-usb node
Date: Thu, 3 Oct 2013 12:59:06 +0300
Message-ID: <1380794346-30185-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380794346-30185-1-git-send-email-rogerq@ti.com>
References: <1380794346-30185-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split USB2 PHY and USB3 PHY into separate omap-control-usb
nodes. Get rid of "ti,type" property.

CC: Benoit Cousson <bcousson@baylibre.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 7cdea1b..c0ec6dc 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -626,12 +626,16 @@
 			hw-caps-temp-alert;
 		};
 
-		omap_control_usb: omap-control-usb@4a002300 {
-			compatible = "ti,omap-control-usb";
-			reg = <0x4a002300 0x4>,
-			      <0x4a002370 0x4>;
-			reg-names = "control_dev_conf", "phy_power_usb";
-			ti,type = <2>;
+		omap_control_usb2phy: control-phy@4a002300 {
+			compatible = "ti,control-phy-usb2";
+			reg = <0x4a002300 0x4>;
+			reg-names = "power";
+		};
+
+		omap_control_usb3phy: control-phy@4a002370 {
+			compatible = "ti,control-phy-pipe3";
+			reg = <0x4a002370 0x4>;
+			reg-names = "power";
 		};
 
 		omap_dwc3@4a020000 {
@@ -662,7 +666,7 @@
 			usb2_phy: usb2phy@4a084000 {
 				compatible = "ti,omap-usb2";
 				reg = <0x4a084000 0x7c>;
-				ctrl-module = <&omap_control_usb>;
+				ctrl-module = <&omap_control_usb2phy>;
 			};
 
 			usb3_phy: usb3phy@4a084400 {
@@ -671,7 +675,7 @@
 				      <0x4a084800 0x64>,
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
-				ctrl-module = <&omap_control_usb>;
+				ctrl-module = <&omap_control_usb3phy>;
 			};
 		};
 
-- 
1.7.4.1


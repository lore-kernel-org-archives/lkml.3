Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3HAOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:05:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56929 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab3HAOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:37 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: [PATCH 6/7] ARM: dts: omap4: update omap-control-usb nodes
Date: Thu, 1 Aug 2013 17:05:14 +0300
Message-ID: <1375365915-21380-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split otghs_ctrl and USB2 PHY power down into separate
omap-control-usb nodes. Update ti,mode property.

CC: Benoit Cousson <benoit.cousson@linaro.org>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 22d9f2b..9a6fa27 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -519,7 +519,7 @@
 			usb2_phy: usb2phy@4a0ad080 {
 				compatible = "ti,omap-usb2";
 				reg = <0x4a0ad080 0x58>;
-				ctrl-module = <&omap_control_usb>;
+				ctrl-module = <&omap_control_usb2phy>;
 			};
 		};
 
@@ -643,11 +643,17 @@
 			};
 		};
 
-		omap_control_usb: omap-control-usb@4a002300 {
+		omap_control_usb2phy: omap-control-usb@4a002300 {
 			compatible = "ti,omap-control-usb";
-			reg = <0x4a002300 0x4>,
-			      <0x4a00233c 0x4>;
-			reg-names = "control_dev_conf", "otghs_control";
+			reg = <0x4a002300 0x4>;
+			reg-names = "power";
+			ti,type = <2>;
+		};
+
+		omap_control_usbotg: omap-control-usb@4a00233c {
+			compatible = "ti,omap-control-usb";
+			reg = <0x4a00233c 0x4>;
+			reg-names = "otghs_control";
 			ti,type = <1>;
 		};
 
@@ -662,6 +668,7 @@
 			num-eps = <16>;
 			ram-bits = <12>;
 			ti,has-mailbox;
+			ctrl-module = <&omap_control_usbotg>;
 		};
 	};
 };
-- 
1.7.4.1


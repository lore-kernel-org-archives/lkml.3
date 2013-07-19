Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab3GSMfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:35:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48953 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923Ab3GSMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:35:06 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 3/4] arm: dts: Add USB phy nodes for AM33XX
Date: Fri, 19 Jul 2013 18:04:36 +0530
Message-ID: <1374237277-17769-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add phy nodes for AM33XX platform and split the musb nodes
per instance.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 68 +++++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 8e1248f..e3890c4 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -326,21 +326,59 @@
 			status = "disabled";
 		};
 
-		usb@47400000 {
-			compatible = "ti,musb-am33xx";
-			reg = <0x47400000 0x1000	/* usbss */
-			       0x47401000 0x800		/* musb instance 0 */
-			       0x47401800 0x800>;	/* musb instance 1 */
-			interrupts = <17		/* usbss */
-				      18		/* musb instance 0 */
-				      19>;		/* musb instance 1 */
-			multipoint = <1>;
-			num-eps = <16>;
-			ram-bits = <12>;
-			port0-mode = <3>;
-			port1-mode = <3>;
-			power = <250>;
-			ti,hwmods = "usb_otg_hs";
+		phy1: am335x-usb0@44e10620 {
+			compatible = "ti,am335x-usb2";
+			#phy-cells = <0>;
+			id= <0>;
+		};
+
+		phy2: am335x-usb1@44e10628 {
+			compatible = "ti,am335x-usb2";
+			#phy-cells = <0>;
+			id= <1>;
+		};
+
+		omap_control_usb: omap-control-usb@44e10620 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x44e10620 0x10>;
+			reg-names = "control_dev_conf";
+			ti,type = <3>;
+		};
+
+                musb: usb@47400000 {
+                        compatible = "ti,musb-am33xx";
+                        reg = <0x47400000 0x1000>;
+                        ranges;
+                        #address-cells = <1>;
+                        #size-cells = <1>;
+                        interrupts = <17>;
+                        ti,hwmods = "usb_otg_hs";
+
+                        usb0@47401000 {
+                                reg = <0x47401000 0x800>;
+                                interrupts = <18>;
+                                interrupt-names = "mc";
+                                multipoint = <1>;
+                                num-eps = <16>;
+                                ram-bits = <12>;
+                                port-mode = <3>;
+                                power = <250>;
+                                phys = <&phy1>;
+				phy-names = "am335x-usb0";
+                        };
+
+                        usb1@47401800 {
+                                reg = <0x47401800 0x800>;
+                                interrupts = <19>;
+                                interrupt-names = "mc";
+                                multipoint = <1>;
+                                num-eps = <16>;
+                                ram-bits = <12>;
+                                port-mode = <3>;
+                                power = <250>;
+                                phys = <&phy2>;
+				phy-names = "am335x-usb1";
+			};
 		};
 
 		mac: ethernet@4a100000 {
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaCFO3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:29:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaCFOXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:23:46 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.comg>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 02/13] phy: omap-control: Update DT binding information
Date: Thu, 6 Mar 2014 16:22:54 +0200
Message-ID: <1394115785-28301-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394115785-28301-1-git-send-email-rogerq@ti.com>
References: <1394115785-28301-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move omap-control binding information to the right location.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt   | 25 ++++++++++++++++++++++
 Documentation/devicetree/bindings/usb/omap-usb.txt | 24 ---------------------
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index f671163..5c5b1b0 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -1,5 +1,30 @@
 TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
 
+OMAP CONTROL PHY
+
+Required properties:
+ - compatible: Should be one of
+ "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
+ "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
+                        e.g. USB2_PHY on OMAP5.
+ "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
+                        e.g. USB3 PHY and SATA PHY on OMAP5.
+ "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
+                        DRA7 platform.
+ "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
+                        AM437 platform.
+ - reg : Address and length of the register set for the device. It contains
+   the address of "otghs_control" for control-phy-otghs or "power" register
+   for other types.
+ - reg-names: should be "otghs_control" control-phy-otghs and "power" for
+   other types.
+
+omap_control_usb: omap-control-usb@4a002300 {
+        compatible = "ti,control-phy-otghs";
+        reg = <0x4a00233c 0x4>;
+        reg-names = "otghs_control";
+};
+
 OMAP USB2 PHY
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index c495135..38b2fae 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -76,27 +76,3 @@ omap_dwc3 {
 	ranges;
 };
 
-OMAP CONTROL USB
-
-Required properties:
- - compatible: Should be one of
- "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
- "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
-			e.g. USB2_PHY on OMAP5.
- "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
-			e.g. USB3 PHY and SATA PHY on OMAP5.
- "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
-			DRA7 platform.
- "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
-			AM437 platform.
- - reg : Address and length of the register set for the device. It contains
-   the address of "otghs_control" for control-phy-otghs or "power" register
-   for other types.
- - reg-names: should be "otghs_control" control-phy-otghs and "power" for
-   other types.
-
-omap_control_usb: omap-control-usb@4a002300 {
-	compatible = "ti,control-phy-otghs";
-	reg = <0x4a00233c 0x4>;
-	reg-names = "otghs_control";
-};
-- 
1.8.3.2


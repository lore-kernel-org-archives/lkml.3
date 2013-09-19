Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3ISNGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:06:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab3ISNGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:06:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 02/15] phy: omap-control: Update DT binding information
Date: Thu, 19 Sep 2013 16:05:30 +0300
Message-ID: <1379595943-14622-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1379595943-14622-1-git-send-email-rogerq@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update compatibility string and DT binding document.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/omap-phy.txt |   23 ++++++++++++++++++++
 Documentation/devicetree/bindings/usb/omap-usb.txt |   23 --------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/omap-phy.txt b/Documentation/devicetree/bindings/phy/omap-phy.txt
index 2c485ee..cf45b01 100644
--- a/Documentation/devicetree/bindings/phy/omap-phy.txt
+++ b/Documentation/devicetree/bindings/phy/omap-phy.txt
@@ -1,5 +1,28 @@
 OMAP PHY: DT DOCUMENTATION FOR PHYs in OMAP PLATFORM
 
+OMAP CONTROL PHY
+
+Required properties:
+ - compatible: Should be one of
+ "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
+ "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
+			e.g. USB2_PHY on OMAP5.
+ "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
+			e.g. USB3 PHY and SATA PHY on OMAP5.
+ "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
+			DRA7 platform.
+ - reg : Address and length of the register set for the device. It contains
+   the address of "otghs_control" for control-phy-otghs or "power" register
+   for other types.
+ - reg-names: should be "otghs_control" control-phy-otghs and "power" for
+   other types.
+
+omap_control_otghs: omap-control-phy@4a002300 {
+	compatible = "ti,control-phy-otghs";
+	reg = <0x4a00233c 0x4>;
+	reg-names = "otghs_control";
+};
+
 OMAP USB2 PHY
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index b2bf7b3..4aa8eab 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -79,26 +79,3 @@ omap_dwc3 {
 	clock-names = "usb_otg_ss_refclk960m";
 	ranges;
 };
-
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
1.7.4.1


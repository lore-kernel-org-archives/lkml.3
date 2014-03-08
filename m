Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaCHJaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:30:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35321 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaCHJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:30:00 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/28] phy: omap-usb2: Add different compatible for OMAP5
Date: Sat, 8 Mar 2014 14:59:19 +0530
Message-ID: <1394270969-11851-19-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Add a new compatible for OMAP5 since it does not use any of the
OTG operations as of now.
HAS_SRP and SET_VBUS functionalities are used only for OMAP4.

Update the Documentation also to add new comaptible.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/usb-phy.txt |    3 ++-
 drivers/phy/phy-omap-usb2.c                       |    9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index 03de61a5..ec199a5 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -4,7 +4,8 @@ OMAP USB2 PHY
 
 Required properties:
  - compatible: Should be either of
-	* "ti,omap-usb2" for OMAP4 and OMAP5
+	* "ti,omap-usb2" for OMAP4
+	* "ti,omap5-usb2" for OMAP5
 	* "ti,dra7x-usb2" for DRA7
 	* "ti,am437x-usb2" for AM437x
  - reg : Address and length of the register set for the device.
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index b220202..3cc4aba 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -154,6 +154,11 @@ static const struct usb_phy_data omap_usb2_data = {
 	.flags = OMAP_USB2_HAS_START_SRP | OMAP_USB2_HAS_SET_VBUS,
 };
 
+static const struct usb_phy_data omap5_usb2_data = {
+	.label = "omap5_usb2",
+	.flags = 0,
+};
+
 static const struct usb_phy_data dra7x_usb2_data = {
 	.label = "dra7x_usb2",
 	.flags = OMAP_USB2_CALIBRATE_FALSE_DISCONNECT,
@@ -170,6 +175,10 @@ static const struct of_device_id omap_usb2_id_table[] = {
 		.data = &omap_usb2_data,
 	},
 	{
+		.compatible = "ti,omap5-usb2",
+		.data = &omap5_usb2_data,
+	},
+	{
 		.compatible = "ti,dra7x-usb2",
 		.data = &dra7x_usb2_data,
 	},
-- 
1.7.9.5


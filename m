Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3ISNGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:06:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50574 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3ISNG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:06:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 06/15] phy: omap-pipe3: update compatibility string and DT binding
Date: Thu, 19 Sep 2013 16:05:34 +0300
Message-ID: <1379595943-14622-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1379595943-14622-1-git-send-email-rogerq@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve compatibility string format to "ti,phy-pipe3-<type>"
where <type> can be "usb3" or "sata". Remove "pcie" type
as it is not yet supported due to missing DPLL data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/omap-phy.txt |    3 +--
 drivers/phy/phy-omap-pipe3.c                       |    8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/omap-phy.txt b/Documentation/devicetree/bindings/phy/omap-phy.txt
index cf45b01..8e09ad3 100644
--- a/Documentation/devicetree/bindings/phy/omap-phy.txt
+++ b/Documentation/devicetree/bindings/phy/omap-phy.txt
@@ -47,8 +47,7 @@ usb2phy@4a0ad080 {
 OMAP PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,omap-usb3", "ti,omap-pipe3", "ti,omap-sata"
-   or "ti,omap-pcie"
+ - compatible: Should be "ti,phy-pipe3-usb3" or "ti,phy-pipe3-sata"
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
diff --git a/drivers/phy/phy-omap-pipe3.c b/drivers/phy/phy-omap-pipe3.c
index 19d1664..67eeaeb 100644
--- a/drivers/phy/phy-omap-pipe3.c
+++ b/drivers/phy/phy-omap-pipe3.c
@@ -219,17 +219,13 @@ static struct phy_ops ops = {
 #ifdef CONFIG_OF
 static const struct of_device_id omap_pipe3_id_table[] = {
 	{
-		.compatible = "ti,omap-pipe3",
+		.compatible = "ti,phy-pipe3-usb3",
 		.data = dpll_map_usb,
 	},
 	{
-		.compatible = "ti,omap-sata",
+		.compatible = "ti,phy-pipe3-sata",
 		.data = dpll_map_sata,
 	},
-	{
-		.compatible = "ti,omap-usb3",
-		.data = dpll_map_usb,
-	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_pipe3_id_table);
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3KMXnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:43:05 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1700 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3KMXm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:42:58 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Florian Fainelli" <f.fainelli@gmail.com>
To: grant.likely@linaro.org
cc: rob.herring@calxeda.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Florian Fainelli" <f.fainelli@gmail.com>
Subject: [PATCH] of: make of_get_phy_mode parse 'phy-connection-type'
Date: Wed, 13 Nov 2013 15:42:27 -0800
Message-ID: <1384386147-13817-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
X-WSS-ID: 7E9AD1CC1SC7802857-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the ePAPR v1.1 specification, 'phy-connection-type' is the canonical
property name for describing an Ethernet to PHY connection type. Make
sure that of_get_phy_mode() also attempts to parse that property and
update the comments mentioninng 'phy-mode' to also include
'phy-connection-type'.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/of_net.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 8f9be2e..101a34c 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -13,8 +13,8 @@
 
 /**
  * It maps 'enum phy_interface_t' found in include/linux/phy.h
- * into the device tree binding of 'phy-mode', so that Ethernet
- * device driver can get phy interface from device tree.
+ * into the device tree binding of 'phy-mode' or 'phy-connection-type',
+ * so that Ethernet device driver can get phy interface from device tree.
  */
 static const char *phy_modes[] = {
 	[PHY_INTERFACE_MODE_NA]		= "",
@@ -36,8 +36,9 @@ static const char *phy_modes[] = {
  * of_get_phy_mode - Get phy mode for given device_node
  * @np:	Pointer to the given device_node
  *
- * The function gets phy interface string from property 'phy-mode',
- * and return its index in phy_modes table, or errno in error case.
+ * The function gets phy interface string from property 'phy-mode' or
+ * 'phy-connection-type', and return its index in phy_modes table, or errno in
+ * error case.
  */
 int of_get_phy_mode(struct device_node *np)
 {
@@ -45,8 +46,11 @@ int of_get_phy_mode(struct device_node *np)
 	int err, i;
 
 	err = of_property_read_string(np, "phy-mode", &pm);
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		err = of_property_read_string(np, "phy-connection-type", &pm);
+		if (err < 0)
+			return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(phy_modes); i++)
 		if (!strcasecmp(pm, phy_modes[i]))
-- 
1.8.3.2



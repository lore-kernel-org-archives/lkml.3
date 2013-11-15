Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3KOGXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:23:54 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59838 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3KOGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:23:47 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: grant.likely@linaro.org
Cc: rob.herring@calxeda.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2] of: make of_get_phy_mode parse 'phy-connection-type'
Date: Fri, 15 Nov 2013 06:23:32 +0000
Message-Id: <1384496612-28392-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20131114074711.9A8C5C402E1@trevor.secretlab.ca>
References: <20131114074711.9A8C5C402E1@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the ePAPR v1.1 specification, 'phy-connection-type' is the canonical
property name for describing an Ethernet to PHY connection type. Make
sure that of_get_phy_mode() also attempts to parse that property and
update the comments mentioning 'phy-mode' to also include
'phy-connection-type'.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes since v2:
- reworked the error condition to look nicer per Grant's suggestion
- added Grant's Acked-by tag
- fixed a typo in the commit message on "mentioning"

 drivers/of/of_net.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 8f9be2e..651e249 100644
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
@@ -46,6 +47,8 @@ int of_get_phy_mode(struct device_node *np)
 
 	err = of_property_read_string(np, "phy-mode", &pm);
 	if (err < 0)
+		err = of_property_read_string(np, "phy-connection-type", &pm);
+	if (err < 0)
 		return err;
 
 	for (i = 0; i < ARRAY_SIZE(phy_modes); i++)
-- 
1.8.3.2


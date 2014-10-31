Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaJaIe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:34:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37151 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaJaIeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:34:25 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>
Subject: [PATCH v2] phy: phy-core: use the np present in of_phandle_args to get the PHY
Date: Fri, 31 Oct 2014 14:04:20 +0530
Message-ID: <1414744460-10795-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the node pointer of the PHY provider and then scanning its
child nodes to get a reference to the PHY, directly use the node pointer
present in of_phandle_args to get a reference to the PHY.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
I sent the wrong version of the patch before. Now I'm sending the proper one
without errors and warnings.
 drivers/phy/phy-core.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index ff5eec5..1606ce9 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -414,21 +414,13 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
 {
 	struct phy *phy;
 	struct class_dev_iter iter;
-	struct device_node *node = dev->of_node;
-	struct device_node *child;
 
 	class_dev_iter_init(&iter, phy_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
 		phy = to_phy(dev);
-		if (node != phy->dev.of_node) {
-			for_each_child_of_node(node, child) {
-				if (child == phy->dev.of_node)
-					goto phy_found;
-			}
+		if (args->np != phy->dev.of_node)
 			continue;
-		}
 
-phy_found:
 		class_dev_iter_exit(&iter);
 		return phy;
 	}
-- 
1.7.9.5


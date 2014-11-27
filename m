Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaK0G0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57515 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaK0G0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:31 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/25] phy: phy-core: use the np present in of_phandle_args to get the PHY
Date: Thu, 27 Nov 2014 11:55:59 +0530
Message-ID: <1417069577-1169-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaJ3FYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 01:24:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53838 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaJ3FYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:24:33 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>
Subject: [PATCH] phy: phy-core: use the np present in of_phandle_args to get the PHY
Date: Thu, 30 Oct 2014 10:54:24 +0530
Message-ID: <1414646664-10178-1-git-send-email-kishon@ti.com>
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
 drivers/phy/phy-core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index ff5eec5..25913f4 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -420,15 +420,9 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
 	class_dev_iter_init(&iter, phy_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
 		phy = to_phy(dev);
-		if (node != phy->dev.of_node) {
-			for_each_child_of_node(node, child) {
-				if (child == phy->dev.of_node)
-					goto phy_found;
-			}
+		if (args->np != phy->dev.node)
 			continue;
-		}
 
-phy_found:
 		class_dev_iter_exit(&iter);
 		return phy;
 	}
-- 
1.7.9.5


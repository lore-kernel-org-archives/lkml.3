Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaDCOlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:41:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50288 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbaDCOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:41:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/3] regulator: core: Add of_node_get to of_regulator_match
Date: Thu,  3 Apr 2014 15:32:15 +0100
Message-Id: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, of_regulator_match does not increment the reference count of
the of_nodes it takes new references to. This could cause the node
pointer held to be invalid, by the time it is passed to the regulator
core. This patchs adds an of_node_get when we copy each of_node pointer
into the match structure.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/of_regulator.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ea4f36f..c58c8d1 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -119,7 +119,8 @@ EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
  * regulator. The data parsed from a child node will be matched to a regulator
  * based on either the deprecated property regulator-compatible if present,
  * or otherwise the child node's name. Note that the match table is modified
- * in place.
+ * in place and an additional of_node reference is taken for each matched
+ * regulator.
  *
  * Returns the number of matches found or a negative error code on failure.
  */
@@ -162,7 +163,7 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 					child->name);
 				return -EINVAL;
 			}
-			match->of_node = child;
+			match->of_node = of_node_get(child);
 			count++;
 			break;
 		}
-- 
1.7.2.5


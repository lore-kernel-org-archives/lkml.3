Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbbAVRKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:10:22 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49315 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbAVRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:10:19 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH] of/unittest: Remove obsolete code
Date: Thu, 22 Jan 2015 17:10:10 +0000
Message-Id: <1421946610-6609-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ce04b4a9, "Removes OF_UNITTEST dependency on OF_DYNAMIC config
symbol" removes a bunch of code, but missed a few minor bits. Clean it
up by removing the node removal cache and flag.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>
Cc: Rob Herring <robh@kernel.org>
---
 drivers/of/unittest.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 139363af5c88..7aa1d6dae5ba 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -27,11 +27,6 @@ static struct selftest_results {
 	int failed;
 } selftest_results;
 
-#define NO_OF_NODES 3
-static struct device_node *nodes[NO_OF_NODES];
-static int last_node_index;
-static bool selftest_live_tree;
-
 #define selftest(result, fmt, ...) ({ \
 	bool failed = !(result); \
 	if (failed) { \
@@ -830,13 +825,6 @@ static int attach_node_and_children(struct device_node *np)
 		return 0;
 	}
 
-	/* Children of the root need to be remembered for removal */
-	if (np->parent == of_root) {
-		if (WARN_ON(last_node_index >= NO_OF_NODES))
-			return -EINVAL;
-		nodes[last_node_index++] = np;
-	}
-
 	child = np->child;
 	np->child = NULL;
 
@@ -899,10 +887,7 @@ static int __init selftest_data_add(void)
 	}
 
 	if (!of_root) {
-		/* enabling flag for removing nodes */
-		selftest_live_tree = true;
 		of_root = selftest_data_node;
-
 		for_each_of_allnodes(np)
 			__of_attach_node_sysfs(np);
 		of_aliases = of_find_node_by_path("/aliases");
-- 
2.1.0


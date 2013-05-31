Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3EaOub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:50:31 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4190 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3EaOu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:50:26 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] regmap: regcache-rbtree: Fixed node range check on sync
Date: Fri, 31 May 2013 16:45:13 +0200
Message-Id: <1370011513-10816-2-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370011513-10816-1-git-send-email-maarten@treewalker.org>
References: <1370011513-10816-1-git-send-email-maarten@treewalker.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A node starting before the minimum register is no reason to reject it,
since its end could be in range. The check for the end already exists
two lines lower, so we can just remove the incorrect check.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 drivers/base/regmap/regcache-rbtree.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 79f4fca..bd57ed4 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -385,8 +385,6 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
 		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
 
-		if (rbnode->base_reg < min)
-			continue;
 		if (rbnode->base_reg > max)
 			break;
 		if (rbnode->base_reg + rbnode->blklen < min)
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaDAU04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:26:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:28527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaDAU0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:26:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,775,1389772800"; 
   d="scan'208";a="512618386"
From: David Cohen <david.a.cohen@linux.intel.com>
To: broonie@kernel.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Christophe PINCE <jean-christophe.pince@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] regmap: rbtree: improve 64bits memory alignment
Date: Tue,  1 Apr 2014 13:26:48 -0700
Message-Id: <1396384008-14353-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PINCE <jean-christophe.pince@intel.com>

Change regcache_rbtree_node strcuture fields order to align the pointers on
64bits architectures.

Signed-off-by: Jean-Christophe PINCE <jean-christophe.pince@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/base/regmap/regcache-rbtree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 930cad4e5df8..6a7e4fa12854 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -23,16 +23,16 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 static int regcache_rbtree_exit(struct regmap *map);
 
 struct regcache_rbtree_node {
-	/* the actual rbtree node holding this block */
-	struct rb_node node;
-	/* base register handled by this block */
-	unsigned int base_reg;
 	/* block of adjacent registers */
 	void *block;
 	/* Which registers are present */
 	long *cache_present;
+	/* base register handled by this block */
+	unsigned int base_reg;
 	/* number of registers available in the block */
 	unsigned int blklen;
+	/* the actual rbtree node holding this block */
+	struct rb_node node;
 } __attribute__ ((packed));
 
 struct regcache_rbtree_ctx {
-- 
1.9.0


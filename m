Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3H2WbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:31:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39634 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520Ab3H2WbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:31:22 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] genalloc: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
Date: Thu, 29 Aug 2013 15:31:18 -0700
Message-Id: <19f4bf138da20276466d4ae66f8704e762d3e0f0.1377815411.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/genalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index e57cc70..26cf20b 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -187,7 +187,7 @@ int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phy
 	int nbytes = sizeof(struct gen_pool_chunk) +
 				BITS_TO_LONGS(nbits) * sizeof(long);
 
-	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
+	chunk = kzalloc_node(nbytes, GFP_KERNEL, nid);
 	if (unlikely(chunk == NULL))
 		return -ENOMEM;
 
-- 
1.8.1.2.459.gbcd45b4.dirty


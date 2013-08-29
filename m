Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3H2Wbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:31:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55363 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754741Ab3H2Wbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:31:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 2/2] mempool: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
Date: Thu, 29 Aug 2013 15:31:19 -0700
Message-Id: <f172c1f3d71f879d8864ce0374988624c35691ca.1377815411.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <19f4bf138da20276466d4ae66f8704e762d3e0f0.1377815411.git.joe@perches.com>
References: <19f4bf138da20276466d4ae66f8704e762d3e0f0.1377815411.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/mempool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 5499047..659aa42 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -73,7 +73,7 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 			       gfp_t gfp_mask, int node_id)
 {
 	mempool_t *pool;
-	pool = kmalloc_node(sizeof(*pool), gfp_mask | __GFP_ZERO, node_id);
+	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
 	if (!pool)
 		return NULL;
 	pool->elements = kmalloc_node(min_nr * sizeof(void *),
-- 
1.8.1.2.459.gbcd45b4.dirty


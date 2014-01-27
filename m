Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaA0R5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:57:18 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61155 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaA0R5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:57:16 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mm: Fix warning on make htmldocs caused by slab.c
Date: Tue, 28 Jan 2014 02:57:08 +0900
Message-Id: <1390845428-6289-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed following errors while make htmldocs
Warning(/mm/slab.c:1956): No description found for parameter 'page'
Warning(/mm/slab.c:1956): Excess function parameter 'slabp' description in 'slab_destroy'

Incorrect function parameter "slabp" was set instead of "page"

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 mm/slab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index eb043bf..b264214 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1946,7 +1946,7 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
 /**
  * slab_destroy - destroy and release all objects in a slab
  * @cachep: cache pointer being destroyed
- * @slabp: slab pointer being destroyed
+ * @page: page pointer being destroyed
  *
  * Destroy all the objs in a slab, and release the mem back to the system.
  * Before calling the slab must have been unlinked from the cache.  The
-- 
1.9.rc0.19.gb594c97


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaHUIKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:10:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48052 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaHUIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:09:26 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/5] mm/slab: move cache_flusharray() out of unlikely.text section
Date: Thu, 21 Aug 2014 17:09:20 +0900
Message-Id: <1408608562-20339-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, due to likely keyword, compiled code of cache_flusharray() is
on unlikely.text section. Although it is uncommon case compared to
free to cpu cache case, it is common case than free_block(). But,
free_block() is on normal text section. This patch fix this odd situation
to remove likely keyword.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index d80b654..d364e3f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3406,7 +3406,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
 		return;
 
-	if (likely(ac->avail < ac->limit)) {
+	if (ac->avail < ac->limit) {
 		STATS_INC_FREEHIT(cachep);
 	} else {
 		STATS_INC_FREEMISS(cachep);
-- 
1.7.9.5


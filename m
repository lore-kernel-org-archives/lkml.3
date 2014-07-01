Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaGAIYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:24:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32848 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbaGAIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:22:33 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 1/9] slab: add unlikely macro to help compiler
Date: Tue,  1 Jul 2014 17:27:30 +0900
Message-Id: <1404203258-8923-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab_should_failslab() is called on every allocation, so to optimize it
is reasonable. We normally don't allocate from kmem_cache. It is just
used when new kmem_cache is created, so it's very rare case. Therefore,
add unlikely macro to help compiler optimization.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 179272f..f8a0ed1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3067,7 +3067,7 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 
 static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (cachep == kmem_cache)
+	if (unlikely(cachep == kmem_cache))
 		return false;
 
 	return should_failslab(cachep->object_size, flags, cachep->flags);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaEGGEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:04:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42204 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaEGGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:04:38 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 01/10] slab: add unlikely macro to help compiler
Date: Wed,  7 May 2014 15:06:11 +0900
Message-Id: <1399442780-28748-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab_should_failslab() is called on every allocation, so to optimize it
is reasonable. We normally don't allocate from kmem_cache. It is just
used when new kmem_cache is created, so it's very rare case. Therefore,
add unlikely macro to help compiler optimization.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 25317fd..1fede40 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2993,7 +2993,7 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 
 static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (cachep == kmem_cache)
+	if (unlikely(cachep == kmem_cache))
 		return false;
 
 	return should_failslab(cachep->object_size, flags, cachep->flags);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaFYOjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:39:52 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54136 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaFYOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:39:51 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <iamjoonsoo.kim@lge.com>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH] slab: document why cache can have no per cpu array on kfree
Date: Wed, 25 Jun 2014 18:39:37 +0400
Message-ID: <1403707177-3740-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140624073840.GC4836@js1304-P5Q-DELUXE>
References: <20140624073840.GC4836@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slab.c b/mm/slab.c
index 6009e44a4d1d..4cb2619277ff 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3530,6 +3530,10 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 	kmemcheck_slab_free(cachep, objp, cachep->object_size);
 
 #ifdef CONFIG_MEMCG_KMEM
+	/*
+	 * Per cpu arrays are disabled for dead memcg caches in order not to
+	 * prevent self-destruction.
+	 */
 	if (unlikely(!ac)) {
 		int nodeid = page_to_nid(virt_to_page(objp));
 
-- 
1.7.10.4


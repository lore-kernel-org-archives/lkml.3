Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3GCAuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:50:25 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39398 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3GCAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:50:18 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 4/5] mm/slub: Drop unnecessary nr_partials
Date: Wed,  3 Jul 2013 08:49:52 +0800
Message-Id: <1372812593-7617-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070300-7014-0000-0000-00000343A16B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unused nr_partials variable.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4649ff0..84b84f4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5269,7 +5269,6 @@ __initcall(slab_sysfs_init);
 #ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
-	unsigned long nr_partials = 0;
 	unsigned long nr_slabs = 0;
 	unsigned long nr_objs = 0;
 	unsigned long nr_free = 0;
@@ -5281,7 +5280,6 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 		if (!n)
 			continue;
 
-		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
 		nr_objs += atomic_long_read(&n->total_objects);
 		nr_free += count_partial(n, count_free);
-- 
1.8.1.2


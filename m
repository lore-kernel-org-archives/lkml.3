Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FZX6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:58:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47762 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3FZX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:57:53 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/3] mm/slub: remove nr_partials
Date: Thu, 27 Jun 2013 07:57:38 +0800
Message-Id: <1372291059-9880-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062623-8878-0000-0000-000007B4C645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unused nr_partials variable.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 939760d..e303b04 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5274,7 +5274,6 @@ __initcall(slab_sysfs_init);
 #ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
-	unsigned long nr_partials = 0;
 	unsigned long nr_slabs = 0;
 	unsigned long nr_objs = 0;
 	unsigned long nr_free = 0;
@@ -5288,7 +5287,6 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 		if (!n)
 			continue;
 
-		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
 		nr_objs += atomic_long_read(&n->total_objects);
 		nr_free += count_partial(n, &nr_inactive, count_free);
-- 
1.8.1.2


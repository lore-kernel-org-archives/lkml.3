Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbbAXLyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:54:20 -0500
Received: from mx2.parallels.com ([199.115.105.18]:48756 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAXLyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:54:16 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] slab: suppress warnings caused by expansion of for_each_memcg_cache if !MEMCG_KMEM
Date: Sat, 24 Jan 2015 14:53:59 +0300
Message-ID: <1422100439-3980-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <201501240937.DoHGo17V%fengguang.wu@intel.com>
References: <201501240937.DoHGo17V%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   In file included from mm/slab_common.c:26:0:
   mm/slab_common.c: In function 'kmem_cache_destroy':
>> mm/slab.h:259:30: warning: right-hand operand of comma expression has no effect [-Wunused-value]
     for (iter = NULL, tmp = NULL, (root); 0; )
                                 ^
>> mm/slab_common.c:603:2: note: in expansion of macro 'for_each_memcg_cache_safe'
     for_each_memcg_cache_safe(c, c2, s) {
     ^

fixes: slab-link-memcg-caches-of-the-same-kind-into-a-list
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 2fc16c2ed198..0a56d76ac0e9 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -254,9 +254,9 @@ extern void slab_init_memcg_params(struct kmem_cache *);
 #else /* !CONFIG_MEMCG_KMEM */
 
 #define for_each_memcg_cache(iter, root) \
-	for (iter = NULL, (root); 0; )
+	for ((void)(iter), (void)(root); 0; )
 #define for_each_memcg_cache_safe(iter, tmp, root) \
-	for (iter = NULL, tmp = NULL, (root); 0; )
+	for ((void)(iter), (void)(tmp), (void)(root); 0; )
 
 static inline bool is_root_cache(struct kmem_cache *s)
 {
-- 
1.7.10.4


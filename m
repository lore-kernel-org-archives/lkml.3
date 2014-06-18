Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaFRORp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:17:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15784 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaFRORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:17:43 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-8e-53a19f85c81b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] mm: slab.h: wrap the whole file with guarding macro
Date: Wed, 18 Jun 2014 18:11:35 +0400
Message-id: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xq7qt8xcGG/w5w26x7dcjNos569ew
	WVz/9obR4vKuOWwW99b8Z7Vo+/yP1eLy1pnMDuwem1Z1snls+jSJ3ePEjN8sHk+uTGfyODnv
	J5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZcy9d5Ol4AFbxa0Pf5gaGNexdjFyckgImEjs
	+XiJCcIWk7hwbz1bFyMXh5DAUkaJGTMWMkI4fUwSjevOMoJUsQnoSfybtZ0NxBYR0JVY9XwX
	M0gRs8AVRol5sxYAFXFwCAu4SGw+EQFSwyKgKnHr2BcWEJtXwFXi4K/5zBDbFCSWLZ/JOoGR
	ewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkND5soNx8TGrQ4wCHIxKPLwf3i4IFmJN
	LCuuzD3EKMHBrCTCO3nmwmAh3pTEyqrUovz4otKc1OJDjEwcnFINjIXSqYfKvb9uXXQweOum
	i4Jnik9/kyj2iXqZI/pJR5ZLsONm09oY7o0Hg+fqtOwKlNlg8kfsE89Hj/pd9Zvbg/b++WLQ
	9K2hVPjRujO2kZ/WlDZ9P2byL0z5p//LuTzMfjm3G/Onlb9r0k1Psp/q1x8S1326LeXKvV0y
	x04EPjjUv/vmUk+lNCWW4oxEQy3mouJEANqxyvT7AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guarding section:
	#ifndef MM_SLAB_H
	#define MM_SLAB_H
	...
	#endif
currently doesn't cover the whole mm/slab.h. It seems like it was
done unintentionally.

Wrap the whole file by moving closing #endif to the end of it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 961a3fb..90954f5e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -260,8 +260,6 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 	WARN_ON_ONCE(1);
 	return s;
 }
-#endif
-
 
 /*
  * The slab lists for all objects.
@@ -296,3 +294,5 @@ struct kmem_cache_node {
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+
+#endif /* MM_SLAB_H */
-- 
1.8.5.5


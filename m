Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaGILRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:17:09 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61610 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaGILKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a3-53bd231a5ce6
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 11/21] mm: slub: share slab_err and object_err
 functions
Date: Wed, 09 Jul 2014 15:01:08 +0400
Message-id: <1404903678-8257-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7pSynuDDR5vlLfY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2PasWmsBZO5Kzo2T2FrYGzl7GLk5JAQMJH4
	teoRC4QtJnHh3nq2LkYuDiGBpYwS1683skM4fUwSlzufMIJUsQnoSfybtZ0NxBYRUJDY3PuM
	FcRmFtCR2HitlQnEFhYIkVgy8TVQMwcHi4CqRO9nLpAwr4CbxPfts1khlilILFs+E8zmBIr3
	9CwAaxUScJVY/Xkb4wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoLgyw7Gxces
	DjEKcDAq8fBq1O4OFmJNLCuuzD3EKMHBrCTCayu6N1iINyWxsiq1KD++qDQntfgQIxMHp1QD
	Y/5m4eK+mNYJXTc2a381min2bpHAuYtza5w3Brzutr16uuTD4jezL69+vWzLYh39jdv8j1V+
	PVdnf3XzjLucqbpmqueUdVnSqrTM/NY9Ytg9a5rWvpVrVNO+rLkpcsh9CYNQlYyxg0/mBt5l
	9893b0vsmrPohH3l0p1B56/yH2abEsOjrLBrwwclluKMREMt5qLiRAASWt9o4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static and add function declarations to mm/slab.h so they
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.h | 5 +++++
 mm/slub.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1257ade..912af7f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -339,5 +339,10 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+void slab_err(struct kmem_cache *s, struct page *page,
+		const char *fmt, ...);
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 
 #endif /* MM_SLAB_H */
diff --git a/mm/slub.c b/mm/slub.c
index 6641a8f..3bdd9ac 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -635,14 +635,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
 }
 
-static void slab_err(struct kmem_cache *s, struct page *page,
+void slab_err(struct kmem_cache *s, struct page *page,
 			const char *fmt, ...)
 {
 	va_list args;
-- 
1.8.5.5


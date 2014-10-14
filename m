Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaJNMAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:00:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41866 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaJNL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:55 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-7b-543d1039c5de
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 8/9] mm/zbud: allow clients to use highmem pages
Date: Tue, 14 Oct 2014 20:59:27 +0900
Message-id: <1413287968-13940-9-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t8zPV1LAdsQg7e/xCzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlHFwznamgTbTi1uvIBsabAl2M
	nBwSAiYSW77uZ4GwxSQu3FvP1sXIxSEksIxRYmXDUxaYooud51ghEosYJaYfOMMKkhASaGeS
	2H7AsouRg4NNQFvi0LZgkLCIQKTE9ocfWUDqmQWOMUpsu/cMrF5YwEXi5punTCA2i4CqxPlD
	h8EW8Aq4S9w/vJcRYpmcxMljk8HqOQU8JJbM3sECsctd4vzsfiaQoRIC29glNh/9zAoxSEDi
	2+RDLCBHSAjISmw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93E
	CImECTsY7x2wPsQowMGoxMNbEGkTIsSaWFZcmXuI0RRow0RmKdHkfGC85ZXEGxqbGVmYmpga
	G5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXGGwTn9kG0fNPP32xgVfI6u
	LW2cOmtW2pM6xqAfErp35qVcrJLwWdEnEszJ5fXj372Nj/OZd67a+tWuqGLWk5x9Ls/dbp/X
	XWgm8PWDB9uSVU3flrEtOnLevXfDtBU2c/f72f9klzB60/5C1HpCs4KlxoPA+pTJZips1d91
	hV/vbxG9uvvXTjslluKMREMt5qLiRABffHGkfwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAV1LAdsQgwkzhC3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzDi4ZjpTQZtoxa3XkQ2MNwW6GDk5JARMJC52nmOFsMUkLtxbz9bFyMUhJLCIUWL6gTNg
	CSGBdiaJ7Qcsuxg5ONgEtCUObQsGCYsIREpsf/iRBaSeWeAYo8S2e8/A6oUFXCRuvnnKBGKz
	CKhKnD90mAXE5hVwl7h/eC8jxDI5iZPHJoPVcwp4SCyZvYMFYpe7xPnZ/UwTGHkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiOs2fSOxhXNVgcYhTgYFTi4S2ItAkRYk0sK67MPcQo
	wcGsJMKrwGEbIsSbklhZlVqUH19UmpNafIjRFOiqicxSosn5wBSQVxJvaGxiZmRpZGZsYm5s
	rCTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBsX6z8s17x+3b575d0qhbJNwzvSxiF9sng/sL
	7RkEozTSp/zbPK3LsFXsT0/NXmGJhOynhVxfdGSZnQ4td6qZtXf9+onvH7/jb/gaxSnsyTc7
	x+Xd02ex54XurAnZP3XlidgN7XETRLaecj68TENjn6VHYfy9pp2OJXp6W9pvv129L4PJbBXj
	XiWW4oxEQy3mouJEAPgp1wnJAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all fields for the internal data structure of zbud are moved to
struct page, there is no reason to restrict zbud pages to be allocated
only in lowmem. This patch allows to use highmem pages for zbud pages.
Pages from highmem are mapped using kmap_atomic() before accessing.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 5a392f3..677fdc1 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -52,6 +52,7 @@
 #include <linux/spinlock.h>
 #include <linux/zbud.h>
 #include <linux/zpool.h>
+#include <linux/highmem.h>
 
 /*****************
  * Structures
@@ -94,6 +95,9 @@ struct zbud_pool {
 	struct zbud_ops *ops;
 };
 
+/* per-cpu mapping addresses of kmap_atomic()'ed zbud pages */
+static DEFINE_PER_CPU(void *, zbud_mapping);
+
 /*****************
  * zpool
  ****************/
@@ -310,9 +314,6 @@ void zbud_destroy_pool(struct zbud_pool *pool)
  * performed first. If no suitable free region is found, then a new page is
  * allocated and added to the pool to satisfy the request.
  *
- * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
- * as zbud pool pages.
- *
  * Return: 0 if success and handle is set, otherwise -EINVAL if the size or
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
@@ -324,7 +325,7 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	enum buddy bud;
 	struct page *page;
 
-	if (!size || (gfp & __GFP_HIGHMEM))
+	if (!size)
 		return -EINVAL;
 	if (size > PAGE_SIZE - CHUNK_SIZE)
 		return -ENOSPC;
@@ -543,14 +544,24 @@ next:
  */
 void *zbud_map(struct zbud_pool *pool, unsigned long handle)
 {
+	void **mapping;
 	size_t offset = 0;
 	struct page *page = handle_to_zbud_page(handle);
 
+	/*
+	 * Because we use per-cpu mapping shared among the pools/users,
+	 * we can't allow mapping in interrupt context because it can
+	 * corrupt another users mappings.
+	 */
+	BUG_ON(in_interrupt());
+
 	if (is_last_chunk(handle))
 		offset = PAGE_SIZE -
 				(get_num_chunks(page, LAST) << CHUNK_SHIFT);
 
-	return (unsigned char *) page_address(page) + offset;
+	mapping = &get_cpu_var(zbud_mapping);
+	*mapping = kmap_atomic(page);
+	return (char *) *mapping + offset;
 }
 
 /**
@@ -560,6 +571,10 @@ void *zbud_map(struct zbud_pool *pool, unsigned long handle)
  */
 void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
 {
+	void **mapping = this_cpu_ptr(&zbud_mapping);
+
+	kunmap_atomic(*mapping);
+	put_cpu_var(zbud_mapping);
 }
 
 /**
-- 
1.9.1


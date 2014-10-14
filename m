Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaJNMAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:00:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaJNMAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:00:02 -0400
X-AuditID: cbfee68e-f79b46d000002b74-db-543d103992e7
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 6/9] mm/zbud: remove list_head for buddied list from
 zbud_header
Date: Tue, 14 Oct 2014 20:59:25 +0900
Message-id: <1413287968-13940-7-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t8zbV1LAdsQg53XOCzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlNNy6xlLwULXix8PtrA2M6+W6
	GDk4JARMJP494eti5AQyxSQu3FvP1sXIxSEksIxRouvYYkaIhInEsckdjBCJRYwS+w6eZANJ
	CAm0M0nsXxsEMohNQFvi0LZgkLCIQKTE9ocfWUDqmQWOMUpsu/eMFSQhLBAmsbb9N5jNIqAq
	8f3jBiYQm1fAXWLy/89sEMvkJE4emwxWwyngIbFk9g4WiF3uEudn9zOBDJUQ2MUusXbLVqhB
	AhLfJh9igfhGVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4m
	Rkgk9O1gvHnA+hCjAAejEg+vRLhNiBBrYllxZe4hRlOgDROZpUST84HxllcSb2hsZmRhamJq
	bGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PGl3fmDueF+sV9C9x7i3K1
	b6yw1bDZZrIvZsW3N6sWhCr/bO/Ln771I7v4hL6fGQWb+lmFS9f1S58X7AhwZ/lkufPF/uR7
	PZbv5kku+HK24l7H+/p1Ogwu2kY+14Xm6O+TtX/c1Cb8/OzBJVedHmT9PfXaRn1uwOR1FskZ
	78XOSq0P+3HXNUCJpTgj0VCLuag4EQBK03FAfwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV1LAdsQg4NHWSzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzGi4dY2l4KFqxY+H21kbGNfLdTFyckgImEgcm9zBCGGLSVy4t56ti5GLQ0hgEaPEvoMn
	2UASQgLtTBL71wZ1MXJwsAloSxzaFgwSFhGIlNj+8CMLSD2zwDFGiW33nrGCJIQFwiTWtv8G
	s1kEVCW+f9zABGLzCrhLTP7/mQ1imZzEyWOTwWo4BTwklszewQKxy13i/Ox+pgmMvAsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfaM+kdjKsaLA4xCnAwKvHwFkTahAixJpYVV+Ye
	YpTgYFYS4VXgsA0R4k1JrKxKLcqPLyrNSS0+xGgKdNVEZinR5HxgEsgriTc0NjEzsjQyMzYx
	NzZWEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cDIL2li+El+R/D2DW09TbzWmx82vTux5+dm
	sfrJahFyUR3nk7r3HT9xoCbx+ZNtCcv/32pQOrfk8NctG7bf6RKYd/h9Ys1OIbOH0XrvvzRv
	3mbwXdz90FweNon7V5yu+22Z4z/f0OdBzoEPSwNbNnIe6pX6u/fO91frxKsmHHqeeX/eO72N
	dkLf85VYijMSDbWYi4oTAQKz5wzKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud allocator links the _unbuddied_ zbud pages into a list in the pool.
When it tries to allocate some spaces, the list is first searched for
the best fit possible. Thus, current implementation has a list_head in
zbud_header structure to construct the list.

This patch simulates a list using the second double word of struct page,
instead of zbud_header. Then, we can eliminate the list_head in
zbud_header. Using _index and _mapcount fields (also including _count on
64-bits machines) in the page struct for list management looks a bit
odd, but no better idea now considering that page->lru is already in
use.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 383bab0..8a6dd6b 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -99,10 +99,8 @@ struct zbud_pool {
 /*
  * struct zbud_header - zbud page metadata occupying the first chunk of each
  *			zbud page.
- * @buddy:	links the zbud page into the unbuddied lists in the pool
  */
 struct zbud_header {
-	struct list_head buddy;
 	bool under_reclaim;
 };
 
@@ -223,21 +221,24 @@ static size_t get_num_chunks(struct page *page, enum buddy bud)
 	for ((_iter) = (_begin); (_iter) < NCHUNKS; (_iter)++)
 
 /* Initializes the zbud header of a newly allocated zbud page */
-static struct zbud_header *init_zbud_page(struct page *page)
+static void init_zbud_page(struct page *page)
 {
 	struct zbud_header *zhdr = page_address(page);
 	set_num_chunks(page, FIRST, 0);
 	set_num_chunks(page, LAST, 0);
-	INIT_LIST_HEAD(&zhdr->buddy);
+	INIT_LIST_HEAD((struct list_head *) &page->index);
 	INIT_LIST_HEAD(&page->lru);
 	zhdr->under_reclaim = 0;
-	return zhdr;
 }
 
 /* Resets the struct page fields and frees the page */
 static void free_zbud_page(struct zbud_header *zhdr)
 {
-	__free_page(virt_to_page(zhdr));
+	struct page *page = virt_to_page(zhdr);
+
+	init_page_count(page);
+	page_mapcount_reset(page);
+	__free_page(page);
 }
 
 static int is_last_chunk(unsigned long handle)
@@ -341,7 +342,6 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
-	struct zbud_header *zhdr = NULL;
 	enum buddy bud;
 	struct page *page;
 
@@ -355,10 +355,9 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	/* First, try to find an unbuddied zbud page. */
 	for_each_unbuddied_list(i, chunks) {
 		if (!list_empty(&pool->unbuddied[i])) {
-			zhdr = list_first_entry(&pool->unbuddied[i],
-					struct zbud_header, buddy);
-			page = virt_to_page(zhdr);
-			list_del(&zhdr->buddy);
+			page = list_entry((unsigned long *)
+				pool->unbuddied[i].next, struct page, index);
+			list_del((struct list_head *) &page->index);
 			goto found;
 		}
 	}
@@ -370,7 +369,7 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 		return -ENOMEM;
 	spin_lock(&pool->lock);
 	pool->pages_nr++;
-	zhdr = init_zbud_page(page);
+	init_zbud_page(page);
 
 found:
 	if (get_num_chunks(page, FIRST) == 0)
@@ -384,7 +383,8 @@ found:
 		get_num_chunks(page, LAST) == 0) {
 		/* Add to unbuddied list */
 		freechunks = num_free_chunks(page);
-		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		list_add((struct list_head *) &page->index,
+				&pool->unbuddied[freechunks]);
 	}
 
 	/* Add/move zbud page to beginning of LRU */
@@ -433,14 +433,15 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 	freechunks = num_free_chunks(page);
 	if (freechunks == NCHUNKS) {
 		/* Remove from existing unbuddied list */
-		list_del(&zhdr->buddy);
+		list_del((struct list_head *) &page->index);
 		/* zbud page is empty, free */
 		list_del(&page->lru);
 		free_zbud_page(zhdr);
 		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
-		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		list_add((struct list_head *) &page->index,
+				&pool->unbuddied[freechunks]);
 	}
 
 	spin_unlock(&pool->lock);
@@ -501,7 +502,7 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		page = list_tail_entry(&pool->lru, struct page, lru);
 		zhdr = page_address(page);
 		list_del(&page->lru);
-		list_del(&zhdr->buddy);
+		list_del((struct list_head *) &page->index);
 		/* Protect zbud page against free */
 		zhdr->under_reclaim = true;
 		/*
@@ -543,7 +544,8 @@ next:
 		} else if (get_num_chunks(page, FIRST) == 0 ||
 				get_num_chunks(page, LAST) == 0) {
 			/* add to unbuddied list */
-			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+			list_add((struct list_head *) &page->index,
+					&pool->unbuddied[freechunks]);
 		}
 
 		/* add to beginning of LRU */
-- 
1.9.1


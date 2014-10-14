Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaJNMBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:01:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41866 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaJNL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:58 -0400
X-AuditID: cbfee68e-f79b46d000002b74-dd-543d10395250
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 7/9] mm/zbud: drop zbud_header
Date: Tue, 14 Oct 2014 20:59:26 +0900
Message-id: <1413287968-13940-8-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t8zLV1LAdsQg1U3BCzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlbHmxnK2g26Tiy6cJTA2M1zW7
	GDk5JARMJDrb17JD2GISF+6tZ+ti5OIQEljGKPFz0QEmmKJF354yg9hCAosYJVaukYew25kk
	9q8N6mLk4GAT0JY4tC0YJCwiECmx/eFHFpA5zALHGCW23XvGCpIQFjCS+P2gDWwmi4CqRGfL
	dbDFvALuEn13TzBD7JKTOHlsMlg9p4CHxJLZO1ggdrlLnJ/dzwQyVEJgG7vE8dWLWCEGCUh8
	m3yIBeQICQFZiU0HoOZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxgh
	kdC3g/HmAetDjAIcjEo8vBLhNiFCrIllxZW5hxhNgTZMZJYSTc4HxlteSbyhsZmRhamJqbGR
	uaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2McU7zYpnmHz6fcLGF7X74l73B
	24QvVO7LijG4xTZN68isX98zE0R/uDze+/2e+K2Nd385cfQr7JkeZTG7MCyT/WfiqhtJl3Yp
	d388vmruQUeOJzJOL2ZH2W8PXsnRGLpurd3WQ6ZfjZSmzFt8/o69xL6b/QK8vp6z//uzuLmU
	XPn5rrnrvoJklxJLcUaioRZzUXEiAGc/4Pd/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAV1LAdsQg3tvuS3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzNjyYjlbQbdJxZdPE5gaGK9rdjFyckgImEgs+vaUGcIWk7hwbz0biC0ksIhRYuUaeQi7
	nUli/9qgLkYODjYBbYlD24JBwiICkRLbH35k6WLk4mAWOMYose3eM1aQhLCAkcTvB21MIDaL
	gKpEZ8t1dhCbV8Bdou/uCahdchInj00Gq+cU8JBYMnsHC8Qud4nzs/uZJjDyLmBkWMUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRHGfPpHcwrmqwOMQowMGoxMNbEGkTIsSaWFZcmXuIUYKD
	WUmEV4HDNkSINyWxsiq1KD++qDQntfgQoynQVROZpUST84EpIK8k3tDYxMzI0sjM2MTc2FhJ
	nPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA+N0P5vY6O+CM9nu6odtqWj7L+uhZijcVzO98+PE
	Xdl+WwKm6zeJr9i8h8NbtdDXKyTx/M3ZE1++YxJs0v9Q+ezw471MfPnfG5q+v0+rnufvfbzY
	ad6ppw+mRveqxv20jS7qvKnl+tnUhPFnnPWJ9Z8DPzdNlBQqPiY6e4XlxoK/07m+e3qe7lJi
	Kc5INNRiLipOBACGPiifyQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the only field in zbud_header is .under_reclaim, get it out of
the struct and let PG_reclaim bit in page->flags take over. As a result
of this change, we can finally eliminate the struct zbud_header, and
hence all the internal data structures of zbud live in struct page.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 66 +++++++++++++++++----------------------------------------------
 1 file changed, 18 insertions(+), 48 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 8a6dd6b..5a392f3 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -60,17 +60,15 @@
  * NCHUNKS_ORDER determines the internal allocation granularity, effectively
  * adjusting internal fragmentation.  It also determines the number of
  * freelists maintained in each pool. NCHUNKS_ORDER of 6 means that the
- * allocation granularity will be in chunks of size PAGE_SIZE/64. As one chunk
- * in allocated page is occupied by zbud header, NCHUNKS will be calculated to
- * 63 which shows the max number of free chunks in zbud page, also there will be
- * 63 freelists per pool.
+ * allocation granularity will be in chunks of size PAGE_SIZE/64.
+ * NCHUNKS will be calculated to 64 which shows the max number of free
+ * chunks in zbud page, also there will be 64 freelists per pool.
  */
 #define NCHUNKS_ORDER	6
 
 #define CHUNK_SHIFT	(PAGE_SHIFT - NCHUNKS_ORDER)
 #define CHUNK_SIZE	(1 << CHUNK_SHIFT)
-#define ZHDR_SIZE_ALIGNED CHUNK_SIZE
-#define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
+#define NCHUNKS		(PAGE_SIZE >> CHUNK_SHIFT)
 
 /**
  * struct zbud_pool - stores metadata for each zbud pool
@@ -96,14 +94,6 @@ struct zbud_pool {
 	struct zbud_ops *ops;
 };
 
-/*
- * struct zbud_header - zbud page metadata occupying the first chunk of each
- *			zbud page.
- */
-struct zbud_header {
-	bool under_reclaim;
-};
-
 /*****************
  * zpool
  ****************/
@@ -220,22 +210,19 @@ static size_t get_num_chunks(struct page *page, enum buddy bud)
 #define for_each_unbuddied_list(_iter, _begin) \
 	for ((_iter) = (_begin); (_iter) < NCHUNKS; (_iter)++)
 
-/* Initializes the zbud header of a newly allocated zbud page */
+/* Initializes a newly allocated zbud page */
 static void init_zbud_page(struct page *page)
 {
-	struct zbud_header *zhdr = page_address(page);
 	set_num_chunks(page, FIRST, 0);
 	set_num_chunks(page, LAST, 0);
 	INIT_LIST_HEAD((struct list_head *) &page->index);
 	INIT_LIST_HEAD(&page->lru);
-	zhdr->under_reclaim = 0;
+	ClearPageReclaim(page);
 }
 
 /* Resets the struct page fields and frees the page */
-static void free_zbud_page(struct zbud_header *zhdr)
+static void free_zbud_page(struct page *page)
 {
-	struct page *page = virt_to_page(zhdr);
-
 	init_page_count(page);
 	page_mapcount_reset(page);
 	__free_page(page);
@@ -261,14 +248,6 @@ static struct page *handle_to_zbud_page(unsigned long handle)
 	return (struct page *) (handle & ~LAST);
 }
 
-/* Returns the zbud page where a given handle is stored */
-static struct zbud_header *handle_to_zbud_header(unsigned long handle)
-{
-	struct page *page = handle_to_zbud_page(handle);
-
-	return page_address(page);
-}
-
 /* Returns the number of free chunks in a zbud page */
 static int num_free_chunks(struct page *page)
 {
@@ -347,7 +326,7 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 
 	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;
-	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
+	if (size > PAGE_SIZE - CHUNK_SIZE)
 		return -ENOSPC;
 	chunks = size_to_chunks(size);
 	spin_lock(&pool->lock);
@@ -410,21 +389,18 @@ found:
  */
 void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
-	struct zbud_header *zhdr;
 	struct page *page;
 	int freechunks;
 
 	spin_lock(&pool->lock);
-	zhdr = handle_to_zbud_header(handle);
-	page = virt_to_page(zhdr);
+	page = handle_to_zbud_page(handle);
 
-	/* If first buddy, handle will be page aligned */
-	if ((handle - ZHDR_SIZE_ALIGNED) & ~PAGE_MASK)
-		set_num_chunks(page, LAST, 0);
-	else
+	if (!is_last_chunk(handle))
 		set_num_chunks(page, FIRST, 0);
+	else
+		set_num_chunks(page, LAST, 0);
 
-	if (zhdr->under_reclaim) {
+	if (PageReclaim(page)) {
 		/* zbud page is under reclaim, reclaim will free */
 		spin_unlock(&pool->lock);
 		return;
@@ -436,7 +412,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		list_del((struct list_head *) &page->index);
 		/* zbud page is empty, free */
 		list_del(&page->lru);
-		free_zbud_page(zhdr);
+		free_zbud_page(page);
 		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
@@ -489,7 +465,6 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
 	int i, ret, freechunks;
 	struct page *page;
-	struct zbud_header *zhdr;
 	unsigned long first_handle, last_handle;
 
 	spin_lock(&pool->lock);
@@ -500,11 +475,10 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 	}
 	for (i = 0; i < retries; i++) {
 		page = list_tail_entry(&pool->lru, struct page, lru);
-		zhdr = page_address(page);
 		list_del(&page->lru);
 		list_del((struct list_head *) &page->index);
 		/* Protect zbud page against free */
-		zhdr->under_reclaim = true;
+		SetPageReclaim(page);
 		/*
 		 * We need encode the handles before unlocking, since we can
 		 * race with free that will set (first|last)_chunks to 0
@@ -530,14 +504,14 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		}
 next:
 		spin_lock(&pool->lock);
-		zhdr->under_reclaim = false;
+		ClearPageReclaim(page);
 		freechunks = num_free_chunks(page);
 		if (freechunks == NCHUNKS) {
 			/*
 			 * Both buddies are now free, free the zbud page and
 			 * return success.
 			 */
-			free_zbud_page(zhdr);
+			free_zbud_page(page);
 			pool->pages_nr--;
 			spin_unlock(&pool->lock);
 			return 0;
@@ -569,14 +543,12 @@ next:
  */
 void *zbud_map(struct zbud_pool *pool, unsigned long handle)
 {
-	size_t offset;
+	size_t offset = 0;
 	struct page *page = handle_to_zbud_page(handle);
 
 	if (is_last_chunk(handle))
 		offset = PAGE_SIZE -
 				(get_num_chunks(page, LAST) << CHUNK_SHIFT);
-	else
-		offset = ZHDR_SIZE_ALIGNED;
 
 	return (unsigned char *) page_address(page) + offset;
 }
@@ -604,8 +576,6 @@ u64 zbud_get_pool_size(struct zbud_pool *pool)
 
 static int __init init_zbud(void)
 {
-	/* Make sure the zbud header will fit in one chunk */
-	BUILD_BUG_ON(sizeof(struct zbud_header) > ZHDR_SIZE_ALIGNED);
 	pr_info("loaded\n");
 
 #ifdef CONFIG_ZPOOL
-- 
1.9.1


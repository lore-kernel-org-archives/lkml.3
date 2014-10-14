Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaJNMBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:01:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32780 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaJNL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:54 -0400
X-AuditID: cbfee691-f79b86d000004a5a-f5-543d103838b7
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 4/9] mm/zbud: remove first|last_chunks from zbud_header
Date: Tue, 14 Oct 2014 20:59:23 +0900
Message-id: <1413287968-13940-5-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t8zTV0LAdsQg94DFhZz1q9hs3h5SNPi
	QttuFouDs5cwWVzeNYfN4t6a/6wWG1pmsVt8OvqIzaJx9zs2B06PpxMOMnls+jSJ3ePEjN8s
	Hn1bVjF6XP9W5LHz02ZWj8+b5ALYo7hsUlJzMstSi/TtErgy/t/QLWjQr9j3/CVzA+Mq1S5G
	Tg4JAROJ6Rt+MkPYYhIX7q1nA7GFBJYxSvyfwA9TM3/nYpYuRi6g+CJGie9/VjBDFLUzSexf
	G9TFyMHBJqAtcWhbMEhYRCBSYvvDj2D1zALHGCW23XvGCpIQFvCWaP2ykwXEZhFQlej/PpMJ
	pJdXwF2i76gHxC45iZPHJoOVcwp4SCyZvYMFYpW7xPnZ/UwgMyUEtrFLrNg4lxVijoDEt8mH
	WEDmSAjISmw6APWLpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREgUT
	dzDeP2B9iFGAg1GJh7cw0iZEiDWxrLgy9xCjKdCGicxSosn5wFjLK4k3NDYzsjA1MTU2Mrc0
	UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcW/w//tH16x4bywoPpctYZeNxGIb
	9+Difc4Hz7q0tIZoG9xVD9m26MjakyVeaVbrbhinc0n/eNRecs5ceU3DZZfpnrVGV97Mnh4X
	K6bJt1f2R5dIaNatrqjiWDf5Fa6eAkddnlSLrjg8tUouuOzAiutMVmetg3M/TlFk5biZEnH2
	T0bo6QM7lFiKMxINtZiLihMBARu5UX0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jAV0LAdsQgz2fjSzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzPh/Q7egQb9i3/OXzA2Mq1S7GDk5JARMJObvXMwCYYtJXLi3nq2LkYtDSGARo8T3PyuY
	QRJCAu1MEvvXBnUxcnCwCWhLHNoWDBIWEYiU2P7wIwtIPbPAMUaJbfeesYIkhAW8JVq/7AQb
	yiKgKtH/fSYTSC+vgLtE31EPiF1yEiePTQYr5xTwkFgyewcLxCp3ifOz+5kmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcZc+kdzCuarA4xCjAwajEw1sQaRMixJpYVlyZe4hR
	goNZSYRXgcM2RIg3JbGyKrUoP76oNCe1+BCjKdBRE5mlRJPzgQkgryTe0NjEzMjSyMzYxNzY
	WEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDY7/DqfDtZ6UUNxkG5fJkXCpwnVz/eDLTS2nJ
	auZj+QETehYZri2OOZN0NVnrXcxUVodb054/PdEivkn/1d6bK9eHOr3sNT3qdejlXQG75Au8
	2THBETUVrOocGlIPuj5kTFfKPn367HP5a4+X2j3wD/P5NyFY8q2F4d24q0nbr3N+jlwvO3tt
	sxJLcUaioRZzUXEiAEDs4pTIAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size information of each first and last buddy are stored into
first|last_chunks in struct zbud_header respectively. Put them into
page->private instead of zbud_header.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 62 ++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index a2390f6..193ea4f 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -100,13 +100,9 @@ struct zbud_pool {
  * struct zbud_header - zbud page metadata occupying the first chunk of each
  *			zbud page.
  * @buddy:	links the zbud page into the unbuddied lists in the pool
- * @first_chunks:	the size of the first buddy in chunks, 0 if free
- * @last_chunks:	the size of the last buddy in chunks, 0 if free
  */
 struct zbud_header {
 	struct list_head buddy;
-	unsigned int first_chunks;
-	unsigned int last_chunks;
 	bool under_reclaim;
 };
 
@@ -212,6 +208,17 @@ static int size_to_chunks(size_t size)
 	return (size + CHUNK_SIZE - 1) >> CHUNK_SHIFT;
 }
 
+static void set_num_chunks(struct page *page, enum buddy bud, size_t chunks)
+{
+	page->private = (page->private & (0xffff << (16 * !bud))) |
+				((chunks & 0xffff) << (16 * bud));
+}
+
+static size_t get_num_chunks(struct page *page, enum buddy bud)
+{
+	return (page->private >> (16 * bud)) & 0xffff;
+}
+
 #define for_each_unbuddied_list(_iter, _begin) \
 	for ((_iter) = (_begin); (_iter) < NCHUNKS; (_iter)++)
 
@@ -219,8 +226,8 @@ static int size_to_chunks(size_t size)
 static struct zbud_header *init_zbud_page(struct page *page)
 {
 	struct zbud_header *zhdr = page_address(page);
-	zhdr->first_chunks = 0;
-	zhdr->last_chunks = 0;
+	set_num_chunks(page, FIRST, 0);
+	set_num_chunks(page, LAST, 0);
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&page->lru);
 	zhdr->under_reclaim = 0;
@@ -240,6 +247,7 @@ static void free_zbud_page(struct zbud_header *zhdr)
 static unsigned long encode_handle(struct zbud_header *zhdr, enum buddy bud)
 {
 	unsigned long handle;
+	struct page *page = virt_to_page(zhdr);
 
 	/*
 	 * For now, the encoded handle is actually just the pointer to the data
@@ -252,7 +260,8 @@ static unsigned long encode_handle(struct zbud_header *zhdr, enum buddy bud)
 		/* skip over zbud header */
 		handle += ZHDR_SIZE_ALIGNED;
 	else /* bud == LAST */
-		handle += PAGE_SIZE - (zhdr->last_chunks  << CHUNK_SHIFT);
+		handle += PAGE_SIZE -
+				(get_num_chunks(page, LAST) << CHUNK_SHIFT);
 	return handle;
 }
 
@@ -263,13 +272,14 @@ static struct zbud_header *handle_to_zbud_header(unsigned long handle)
 }
 
 /* Returns the number of free chunks in a zbud page */
-static int num_free_chunks(struct zbud_header *zhdr)
+static int num_free_chunks(struct page *page)
 {
 	/*
 	 * Rather than branch for different situations, just use the fact that
 	 * free buddies have a length of zero to simplify everything.
 	 */
-	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks;
+	return NCHUNKS - get_num_chunks(page, FIRST)
+				- get_num_chunks(page, LAST);
 }
 
 /*****************
@@ -366,17 +376,17 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	zhdr = init_zbud_page(page);
 
 found:
-	if (zhdr->first_chunks == 0) {
-		zhdr->first_chunks = chunks;
+	if (get_num_chunks(page, FIRST) == 0)
 		bud = FIRST;
-	} else {
-		zhdr->last_chunks = chunks;
+	else
 		bud = LAST;
-	}
 
-	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0) {
+	set_num_chunks(page, bud, chunks);
+
+	if (get_num_chunks(page, FIRST) == 0 ||
+		get_num_chunks(page, LAST) == 0) {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
+		freechunks = num_free_chunks(page);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	}
 
@@ -413,9 +423,9 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 
 	/* If first buddy, handle will be page aligned */
 	if ((handle - ZHDR_SIZE_ALIGNED) & ~PAGE_MASK)
-		zhdr->last_chunks = 0;
+		set_num_chunks(page, LAST, 0);
 	else
-		zhdr->first_chunks = 0;
+		set_num_chunks(page, FIRST, 0);
 
 	if (zhdr->under_reclaim) {
 		/* zbud page is under reclaim, reclaim will free */
@@ -423,7 +433,8 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		return;
 	}
 
-	if (num_free_chunks(zhdr) == NCHUNKS) {
+	freechunks = num_free_chunks(page);
+	if (freechunks == NCHUNKS) {
 		/* Remove from existing unbuddied list */
 		list_del(&zhdr->buddy);
 		/* zbud page is empty, free */
@@ -432,7 +443,6 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	}
 
@@ -503,9 +513,9 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		 */
 		first_handle = 0;
 		last_handle = 0;
-		if (zhdr->first_chunks)
+		if (get_num_chunks(page, FIRST))
 			first_handle = encode_handle(zhdr, FIRST);
-		if (zhdr->last_chunks)
+		if (get_num_chunks(page, LAST))
 			last_handle = encode_handle(zhdr, LAST);
 		spin_unlock(&pool->lock);
 
@@ -523,7 +533,8 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 next:
 		spin_lock(&pool->lock);
 		zhdr->under_reclaim = false;
-		if (num_free_chunks(zhdr) == NCHUNKS) {
+		freechunks = num_free_chunks(page);
+		if (freechunks == NCHUNKS) {
 			/*
 			 * Both buddies are now free, free the zbud page and
 			 * return success.
@@ -532,10 +543,9 @@ next:
 			pool->pages_nr--;
 			spin_unlock(&pool->lock);
 			return 0;
-		} else if (zhdr->first_chunks == 0 ||
-				zhdr->last_chunks == 0) {
+		} else if (get_num_chunks(page, FIRST) == 0 ||
+				get_num_chunks(page, LAST) == 0) {
 			/* add to unbuddied list */
-			freechunks = num_free_chunks(zhdr);
 			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 		}
 
-- 
1.9.1


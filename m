Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaJNMBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:01:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaJNL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:59 -0400
X-AuditID: cbfee68f-f791c6d000004834-cc-543d10380b00
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 3/9] mm/zbud: remove lru from zbud_header
Date: Tue, 14 Oct 2014 20:59:22 +0900
Message-id: <1413287968-13940-4-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zLV0LAdsQg18NBhZz1q9hs3h5SNPi
	QttuFouDs5cwWVzeNYfN4t6a/6wWG1pmsVt8OvqIzaJx9zs2B06PpxMOMnls+jSJ3ePEjN8s
	Hn1bVjF6XP9W5LHz02ZWj8+b5ALYo7hsUlJzMstSi/TtErgyns68wlzwXbri0eeHjA2My8W6
	GDk5JARMJA7MOMwEYYtJXLi3nq2LkYtDSGAZo8T+97tYYIpWHPrIApFYxCixb+5ZsA4hgXYm
	if1rg7oYOTjYBLQlDm0LBgmLCERKbH8IUc8scIxRYtu9Z6wgCWEBW4mn+6ewg9gsAqoS3+5+
	AJvDK+AucWnxbagr5CROHpsMVs8p4CGxZPYOFohd7hLnZ/czgQyVENjFLrF3zxtWiEECEt8m
	H2IBOUJCQFZi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZI
	LPTvYLx7wPoQowAHoxIPb0GkTYgQa2JZcWXuIUZToA0TmaVEk/OBEZdXEm9obGZkYWpiamxk
	bmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGSIfjl4S5Lnun3mH9e/zxzR8a
	wgxLzUW8plT3XN6861+nmeHW/GZ91wPLkpJWXIjL91063ef+KndFzgrmHdxTz//wOy3XFXN5
	dc5l29s3j9b7LBVIEImJv3Zk80GrPM0n8lJ1cVeSfnb/73yZceLyZpEDXmYyHzoSrswqNtC4
	EPPt4K5ZVl9MlFiKMxINtZiLihMBIKcN5YACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV0LAdsQg8NntC3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzHg68wpzwXfpikefHzI2MC4X62Lk5JAQMJFYcegjC4QtJnHh3nq2LkYuDiGBRYwS++ae
	ZQJJCAm0M0nsXxvUxcjBwSagLXFoWzBIWEQgUmL7Q5BeLg5mgWOMEtvuPWMFSQgL2Eo83T+F
	HcRmEVCV+Hb3A9gcXgF3iUuLbzNBLJOTOHlsMlg9p4CHxJLZO1ggdrlLnJ/dzzSBkXcBI8Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBIeya9g3FVg8UhRgEORiUe3oJImxAh1sSy4src
	Q4wSHMxKIrwKHLYhQrwpiZVVqUX58UWlOanFhxhNga6ayCwlmpwPTAJ5JfGGxiZmRpZGZsYm
	5sbGSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoY66x2fLTeeOwE23Eh5jffP3y9c/Nio0jJ
	EY1Z7n510sZTS6dev+kQuHdD6q4/ptdU7vnpzbJ5r3zwk5RRc2VV1eu6Xawf+r0fTtzrPlEw
	RZftiSHb8d74n0tr0v8IbWZ3yY7TsH1YHWK4s7rC4KBrinzf2nCWWy7L/05etMTrXOLSUHe5
	J3NjlViKMxINtZiLihMB62cK+coCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud_pool has an lru list for tracking zbud pages and they are strung
together via zhdr->lru. If we reuse page->lru for linking zbud pages
instead of it, the lru field in zbud_header can be dropped.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 0f5add0..a2390f6 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -100,13 +100,11 @@ struct zbud_pool {
  * struct zbud_header - zbud page metadata occupying the first chunk of each
  *			zbud page.
  * @buddy:	links the zbud page into the unbuddied lists in the pool
- * @lru:	links the zbud page into the lru list in the pool
  * @first_chunks:	the size of the first buddy in chunks, 0 if free
  * @last_chunks:	the size of the last buddy in chunks, 0 if free
  */
 struct zbud_header {
 	struct list_head buddy;
-	struct list_head lru;
 	unsigned int first_chunks;
 	unsigned int last_chunks;
 	bool under_reclaim;
@@ -224,7 +222,7 @@ static struct zbud_header *init_zbud_page(struct page *page)
 	zhdr->first_chunks = 0;
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
-	INIT_LIST_HEAD(&zhdr->lru);
+	INIT_LIST_HEAD(&page->lru);
 	zhdr->under_reclaim = 0;
 	return zhdr;
 }
@@ -352,6 +350,7 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 		if (!list_empty(&pool->unbuddied[i])) {
 			zhdr = list_first_entry(&pool->unbuddied[i],
 					struct zbud_header, buddy);
+			page = virt_to_page(zhdr);
 			list_del(&zhdr->buddy);
 			goto found;
 		}
@@ -382,9 +381,9 @@ found:
 	}
 
 	/* Add/move zbud page to beginning of LRU */
-	if (!list_empty(&zhdr->lru))
-		list_del(&zhdr->lru);
-	list_add(&zhdr->lru, &pool->lru);
+	if (!list_empty(&page->lru))
+		list_del(&page->lru);
+	list_add(&page->lru, &pool->lru);
 
 	*handle = encode_handle(zhdr, bud);
 	spin_unlock(&pool->lock);
@@ -405,10 +404,12 @@ found:
 void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
 	struct zbud_header *zhdr;
+	struct page *page;
 	int freechunks;
 
 	spin_lock(&pool->lock);
 	zhdr = handle_to_zbud_header(handle);
+	page = virt_to_page(zhdr);
 
 	/* If first buddy, handle will be page aligned */
 	if ((handle - ZHDR_SIZE_ALIGNED) & ~PAGE_MASK)
@@ -426,7 +427,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		/* Remove from existing unbuddied list */
 		list_del(&zhdr->buddy);
 		/* zbud page is empty, free */
-		list_del(&zhdr->lru);
+		list_del(&page->lru);
 		free_zbud_page(zhdr);
 		pool->pages_nr--;
 	} else {
@@ -479,6 +480,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
 	int i, ret, freechunks;
+	struct page *page;
 	struct zbud_header *zhdr;
 	unsigned long first_handle, last_handle;
 
@@ -489,8 +491,9 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		return -EINVAL;
 	}
 	for (i = 0; i < retries; i++) {
-		zhdr = list_tail_entry(&pool->lru, struct zbud_header, lru);
-		list_del(&zhdr->lru);
+		page = list_tail_entry(&pool->lru, struct page, lru);
+		zhdr = page_address(page);
+		list_del(&page->lru);
 		list_del(&zhdr->buddy);
 		/* Protect zbud page against free */
 		zhdr->under_reclaim = true;
@@ -537,7 +540,7 @@ next:
 		}
 
 		/* add to beginning of LRU */
-		list_add(&zhdr->lru, &pool->lru);
+		list_add(&page->lru, &pool->lru);
 	}
 	spin_unlock(&pool->lock);
 	return -EAGAIN;
-- 
1.9.1


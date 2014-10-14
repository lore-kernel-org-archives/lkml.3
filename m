Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaJNMBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:01:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaJNL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:54 -0400
X-AuditID: cbfee68d-f79296d000004278-d9-543d103847b1
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 1/9] mm/zbud: tidy up a bit
Date: Tue, 14 Oct 2014 20:59:20 +0900
Message-id: <1413287968-13940-2-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zTV0LAdsQg11dPBZz1q9hs3h5SNPi
	QttuFouDs5cwWVzeNYfN4t6a/6wWG1pmsVt8OvqIzaJx9zs2B06PpxMOMnls+jSJ3ePEjN8s
	Hn1bVjF6XP9W5LHz02ZWj8+b5ALYo7hsUlJzMstSi/TtErgypvYuZy64KFbR/HwRWwPjN8Eu
	Rk4OCQETiRufDjNC2GISF+6tZwOxhQSWMUr09ibA1Fz89Jq9i5ELKL6IUeLvhw5mCKedSaLh
	7xsgh4ODTUBb4tC2YJAGEYFIie0PP7KA1DALHGOU2HbvGStIQlhAX+Lq236wbSwCqhLHTi1h
	BrF5BdwlLu+dxAaxTU7i5LHJYPWcAh4SS2bvYIG4yF3i/Ox+JpChEgK72CUmLVjMBjFIQOLb
	5EMsIEdICMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQI
	iYXeHYy3D1gfYhTgYFTi4S2ItAkRYk0sK67MPcRoCrRhIrOUaHI+MOLySuINjc2MLExNTI2N
	zC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgPLf8j2b3y6NL1Lf2bYjj719R
	x3vrZ+jx19tmHfqpy78oWV83nrtgy9F9T/dsu7hVxCE7+avC3G/Jh/MfH8ycNVHrON+GDxmZ
	pSEiO570LFZbe1ZbKbB6xy2d5U8EufUm6dq/uOJ0bPcPvhsGJ9a0X06bcG3uRrF7C2qvfEv7
	NTVv647fxlEM0nFKLMUZiYZazEXFiQDbRC3vgAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV0LAdsQg1ln2S3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzJjau5y54KJYRfPzRWwNjN8Euxg5OSQETCQufnrNDmGLSVy4t56ti5GLQ0hgEaPE3w8d
	zBBOO5NEw983QA4HB5uAtsShbcEgDSICkRLbH35kAalhFjjGKLHt3jNWkISwgL7E1bf9jCA2
	i4CqxLFTS5hBbF4Bd4nLeyexQWyTkzh5bDJYPaeAh8SS2TtYQGwhoJrzs/uZJjDyLmBkWMUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHGvPpHcwrmqwOMQowMGoxMNbEGkTIsSaWFZcmXuI
	UYKDWUmEV4HDNkSINyWxsiq1KD++qDQntfgQoynQVROZpUST84FpIK8k3tDYxMzI0sjM2MTc
	2FhJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUAyPbOYfHfgsLvd7UrQ6ZEL2DcfHkJ9v83/lJ
	XAh/fMpL3yJVbMrEpRtS7oXtXpok97RufaKvo8rlF0KLC1P32j1/yv1u/xzn/qwN/8t4l9wq
	viIrNyN6Y4bMpbeHQta/C7/XqNafnDFD7EWA6cM5h2fnLdLe1H/8zHnPafZrYlaU3vt6UrBB
	um2FEktxRqKhFnNRcSIAj2yZMssCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetics, add a blank line between functions, remove useless
initialization statements, and simplify codes a bit. No functional
differences are introduced.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index ecf1dbe..6f36394 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -145,6 +145,7 @@ static int zbud_zpool_malloc(void *pool, size_t size, gfp_t gfp,
 {
 	return zbud_alloc(pool, size, gfp, handle);
 }
+
 static void zbud_zpool_free(void *pool, unsigned long handle)
 {
 	zbud_free(pool, handle);
@@ -174,6 +175,7 @@ static void *zbud_zpool_map(void *pool, unsigned long handle,
 {
 	return zbud_map(pool, handle);
 }
+
 static void zbud_zpool_unmap(void *pool, unsigned long handle)
 {
 	zbud_unmap(pool, handle);
@@ -350,16 +352,11 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	spin_lock(&pool->lock);
 
 	/* First, try to find an unbuddied zbud page. */
-	zhdr = NULL;
 	for_each_unbuddied_list(i, chunks) {
 		if (!list_empty(&pool->unbuddied[i])) {
 			zhdr = list_first_entry(&pool->unbuddied[i],
 					struct zbud_header, buddy);
 			list_del(&zhdr->buddy);
-			if (zhdr->first_chunks == 0)
-				bud = FIRST;
-			else
-				bud = LAST;
 			goto found;
 		}
 	}
@@ -372,13 +369,15 @@ int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	spin_lock(&pool->lock);
 	pool->pages_nr++;
 	zhdr = init_zbud_page(page);
-	bud = FIRST;
 
 found:
-	if (bud == FIRST)
+	if (zhdr->first_chunks == 0) {
 		zhdr->first_chunks = chunks;
-	else
+		bud = FIRST;
+	} else {
 		zhdr->last_chunks = chunks;
+		bud = LAST;
+	}
 
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0) {
 		/* Add to unbuddied list */
@@ -433,7 +432,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 	/* Remove from existing buddy list */
 	list_del(&zhdr->buddy);
 
-	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+	if (num_free_chunks(zhdr) == NCHUNKS) {
 		/* zbud page is empty, free */
 		list_del(&zhdr->lru);
 		free_zbud_page(zhdr);
@@ -489,7 +488,7 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
 	int i, ret, freechunks;
 	struct zbud_header *zhdr;
-	unsigned long first_handle = 0, last_handle = 0;
+	unsigned long first_handle, last_handle;
 
 	spin_lock(&pool->lock);
 	if (!pool->ops || !pool->ops->evict || list_empty(&pool->lru) ||
@@ -529,7 +528,7 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 next:
 		spin_lock(&pool->lock);
 		zhdr->under_reclaim = false;
-		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+		if (num_free_chunks(zhdr) == NCHUNKS) {
 			/*
 			 * Both buddies are now free, free the zbud page and
 			 * return success.
-- 
1.9.1


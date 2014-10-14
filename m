Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaJNMAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:00:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaJNL74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:56 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-71-543d10389c67
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 2/9] mm/zbud: remove buddied list from zbud_pool
Date: Tue, 14 Oct 2014 20:59:21 +0900
Message-id: <1413287968-13940-3-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zTV0LAdsQg7e7FS3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlnJ52gL3gtWjFtvO3GRsYJwt2
	MXJySAiYSPQ1rGWGsMUkLtxbz9bFyMUhJLCMUeLy3D/MMEX3+iaxQyQWMUo0HprBBJIQEmhn
	kti/NqiLkYODTUBb4tC2YJCwiECkxPaHH1lA6pkFjjFKbLv3jBUkISzgItHysB2sl0VAVWLj
	lUlgcV4Bd4mWjReZIJbJSZw8NhkszingIbFk9g4WiF3uEudn9zOBDJUQ2MYusXvndHaIQQIS
	3yYfYgE5QkJAVmLTAaijJSUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	kFiYsIPx3gHrQ4wCHIxKPLwFkTYhQqyJZcWVuYcYTYE2TGSWEk3OB0ZcXkm8obGZkYWpiamx
	kbmlmZI472upn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGIX/LtNtf/VhyaapPn+WfUut
	bLpnuvl6zrPXAu/4O/19NHLX3jA+HvlswpZPM6amSkeJC28+/Cbm6J5f13KX7p6odDXiRC+v
	xsb/UvodH/zm+2galy+Knca85Oe+6w88b2if87npwjfL4IKDANtPzr71wnb5+dHWyheuuPsq
	1bAL93ULuW1391ZiKc5INNRiLipOBACG22R1gAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV0LAdsQg0UHZC3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzDg97QB7wWvRim3nbzM2ME4W7GLk5JAQMJG41zeJHcIWk7hwbz1bFyMXh5DAIkaJxkMz
	mEASQgLtTBL71wZ1MXJwsAloSxzaFgwSFhGIlNj+8CMLSD2zwDFGiW33nrGCJIQFXCRaHraD
	9bIIqEpsvDIJLM4r4C7RsvEiE8QyOYmTxyaDxTkFPCSWzN7BArHLXeL87H6mCYy8CxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIER9oz6R2MqxosDjEKcDAq8fAWRNqECLEmlhVX5h5i
	lOBgVhLhVeCwDRHiTUmsrEotyo8vKs1JLT7EaAp01URmKdHkfGASyCuJNzQ2MTOyNDIzNjE3
	NlYS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwLi42XBzTugtnvy6byGZrNfOSH3M6rumZJq4
	bPXtnyySVXYJLyY7yHUUmriWp9ceXvFni+V65yulxxYYq/IxH7Pqvm/dffG3dITozi8O2wUN
	rRhVWCq3eer0FkVNMXo1X7fUakrFvq0mmvrVWn1b1wis3lP6nNV41/FduvcNvpsZf9ETrtzW
	pMRSnJFoqMVcVJwIAEz8yGnKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in having the _buddied_ list of zbud_pages, as nobody
refers it. Tracking it adds runtime overheads only, so let's remove it.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 6f36394..0f5add0 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -79,8 +79,6 @@
  * @unbuddied:	array of lists tracking zbud pages that only contain one buddy;
  *		the lists each zbud page is added to depends on the size of
  *		its free region.
- * @buddied:	list tracking the zbud pages that contain two buddies;
- *		these zbud pages are full
  * @lru:	list tracking the zbud pages in LRU order by most recently
  *		added buddy.
  * @pages_nr:	number of zbud pages in the pool.
@@ -93,7 +91,6 @@
 struct zbud_pool {
 	spinlock_t lock;
 	struct list_head unbuddied[NCHUNKS];
-	struct list_head buddied;
 	struct list_head lru;
 	u64 pages_nr;
 	struct zbud_ops *ops;
@@ -102,7 +99,7 @@ struct zbud_pool {
 /*
  * struct zbud_header - zbud page metadata occupying the first chunk of each
  *			zbud page.
- * @buddy:	links the zbud page into the unbuddied/buddied lists in the pool
+ * @buddy:	links the zbud page into the unbuddied lists in the pool
  * @lru:	links the zbud page into the lru list in the pool
  * @first_chunks:	the size of the first buddy in chunks, 0 if free
  * @last_chunks:	the size of the last buddy in chunks, 0 if free
@@ -299,7 +296,6 @@ struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
 	spin_lock_init(&pool->lock);
 	for_each_unbuddied_list(i, 0)
 		INIT_LIST_HEAD(&pool->unbuddied[i]);
-	INIT_LIST_HEAD(&pool->buddied);
 	INIT_LIST_HEAD(&pool->lru);
 	pool->pages_nr = 0;
 	pool->ops = ops;
@@ -383,9 +379,6 @@ found:
 		/* Add to unbuddied list */
 		freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
-	} else {
-		/* Add to buddied list */
-		list_add(&zhdr->buddy, &pool->buddied);
 	}
 
 	/* Add/move zbud page to beginning of LRU */
@@ -429,10 +422,9 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		return;
 	}
 
-	/* Remove from existing buddy list */
-	list_del(&zhdr->buddy);
-
 	if (num_free_chunks(zhdr) == NCHUNKS) {
+		/* Remove from existing unbuddied list */
+		list_del(&zhdr->buddy);
 		/* zbud page is empty, free */
 		list_del(&zhdr->lru);
 		free_zbud_page(zhdr);
@@ -542,9 +534,6 @@ next:
 			/* add to unbuddied list */
 			freechunks = num_free_chunks(zhdr);
 			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
-		} else {
-			/* add to buddied list */
-			list_add(&zhdr->buddy, &pool->buddied);
 		}
 
 		/* add to beginning of LRU */
-- 
1.9.1


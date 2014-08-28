Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaH1Sgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaH1Sgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:39 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 51/97] mm/compaction: clean up unused code lines
Date: Thu, 28 Aug 2014 19:34:59 +0100
Message-Id: <1409250945-30874-52-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heesub Shin <heesub.shin@samsung.com>

commit 13fb44e4b0414d7e718433a49e6430d5b76bd46e upstream.

Remove code lines currently not in use or never called.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5c17302..c5f2f18 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -208,12 +208,6 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
 	return true;
 }
 
-static inline bool compact_trylock_irqsave(spinlock_t *lock,
-			unsigned long *flags, struct compact_control *cc)
-{
-	return compact_checklock_irqsave(lock, flags, false, cc);
-}
-
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
@@ -734,7 +728,6 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		isolated = 0;
 
 		/*
 		 * Take care when isolating in last pageblock of a zone which
@@ -1163,9 +1156,6 @@ static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 			if (zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0))
 				compaction_defer_reset(zone, cc->order, false);
-			/* Currently async compaction is never deferred. */
-			else if (cc->sync)
-				defer_compaction(zone, cc->order);
 		}
 
 		VM_BUG_ON(!list_empty(&cc->freepages));
-- 
1.8.4.5


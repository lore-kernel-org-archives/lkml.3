Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaKSVLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaKSVLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>, Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 107/122] mm/compaction: clean up unused code lines
Date: Wed, 19 Nov 2014 12:52:37 -0800
Message-Id: <20141119205212.392204060@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -208,12 +208,6 @@ static bool compact_checklock_irqsave(sp
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
@@ -736,7 +730,6 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		isolated = 0;
 
 		/*
 		 * Take care when isolating in last pageblock of a zone which
@@ -1165,9 +1158,6 @@ static void __compact_pgdat(pg_data_t *p
 			if (zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0))
 				compaction_defer_reset(zone, cc->order, false);
-			/* Currently async compaction is never deferred. */
-			else if (cc->sync)
-				defer_compaction(zone, cc->order);
 		}
 
 		VM_BUG_ON(!list_empty(&cc->freepages));



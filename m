Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaEMJxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:53:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbaEMJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:45:56 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 02/19] mm: page_alloc: Do not treat a zone that cannot be used for dirty pages as "full"
Date: Tue, 13 May 2014 10:45:33 +0100
Message-Id: <1399974350-11089-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a zone cannot be used for a dirty page then it gets marked "full"
which is cached in the zlc and later potentially skipped by allocation
requests that have nothing to do with dirty zones.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f8b80c3..5c559e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1976,7 +1976,7 @@ zonelist_scan:
 		 */
 		if ((alloc_flags & ALLOC_WMARK_LOW) &&
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
-			goto this_zone_full;
+			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_ok(zone, order, mark,
-- 
1.8.4.5


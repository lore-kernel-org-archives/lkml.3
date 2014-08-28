Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaH1Suf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:50:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbaH1Sg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:58 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 69/97] mm: page_alloc: do not treat a zone that cannot be used for dirty pages as "full"
Date: Thu, 28 Aug 2014 19:35:17 +0100
Message-Id: <1409250945-30874-70-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 800a1e750c7b04c2aa2459afca77e936e01c0029 upstream.

If a zone cannot be used for a dirty page then it gets marked "full" which
is cached in the zlc and later potentially skipped by allocation requests
that have nothing to do with dirty zones.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2834c31..68e0349 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1966,7 +1966,7 @@ zonelist_scan:
 		 */
 		if ((alloc_flags & ALLOC_WMARK_LOW) &&
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
-			goto this_zone_full;
+			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_ok(zone, order, mark,
-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3LTOyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:54:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab3LTOyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:54:17 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] Revert "mm: page_alloc: exclude unreclaimable allocations from zone fairness policy"
Date: Fri, 20 Dec 2013 14:54:11 +0000
Message-Id: <1387551252-23375-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387551252-23375-1-git-send-email-mgorman@suse.de>
References: <1387551252-23375-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 73f038b863dfe98acabc7c36c17342b84ad52e94. The NUMA behaviour of
this patch is less than ideal. An alternative approch is to interleave allocations
only within local zones which is implemented in the next patch.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f861d02..580a5f0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1920,8 +1920,7 @@ zonelist_scan:
 		 * back to remote zones that do not partake in the
 		 * fairness round-robin cycle of this zonelist.
 		 */
-		if ((alloc_flags & ALLOC_WMARK_LOW) &&
-		    (gfp_mask & GFP_MOVABLE_MASK)) {
+		if (alloc_flags & ALLOC_WMARK_LOW) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (zone_reclaim_mode &&
-- 
1.8.4


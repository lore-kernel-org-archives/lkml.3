Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBNGyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:54:16 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53657 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaBNGyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:54:09 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-04-52fdbd8c515c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 5/5] mm/compaction: clean-up code on success of ballon isolation
Date: Fri, 14 Feb 2014 15:54:03 +0900
Message-Id: <1392360843-22261-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is just for clean-up to reduce code size and improve readability.
There is no functional change.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index 56536d3..a1a9270 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -553,11 +553,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			if (unlikely(balloon_page_movable(page))) {
 				if (locked && balloon_page_isolate(page)) {
 					/* Successfully isolated */
-					cc->finished_update_migrate = true;
-					list_add(&page->lru, migratelist);
-					cc->nr_migratepages++;
-					nr_isolated++;
-					goto check_compact_cluster;
+					goto isolate_success;
 				}
 			}
 			continue;
@@ -609,13 +605,14 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
-		cc->finished_update_migrate = true;
 		del_page_from_lru_list(page, lruvec, page_lru(page));
+
+isolate_success:
+		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-check_compact_cluster:
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
-- 
1.7.9.5


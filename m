Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3LFIjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:39:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54474 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3LFIjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:39:14 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-47-52a18d2fe163
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/4] mm/compaction: respect ignore_skip_hint in update_pageblock_skip
Date: Fri,  6 Dec 2013 17:41:50 +0900
Message-Id: <1386319310-28016-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_pageblock_skip() only fits to compaction which tries to isolate by
pageblock unit. If isolate_migratepages_range() is called by CMA, it try to
isolate regardless of pageblock unit and it don't reference
get_pageblock_skip() by ignore_skip_hint. We should also respect it on
update_pageblock_skip() to prevent from setting the wrong information.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index 805165b..f58bcd0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -134,6 +134,10 @@ static void update_pageblock_skip(struct compact_control *cc,
 			bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+
+	if (cc->ignore_skip_hint)
+		return;
+
 	if (!page)
 		return;
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3APAZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:25:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39000 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab3APAZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:43 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 01/17] mm/compaction: rename var zone_end_pfn to avoid conflicts with new function
Date: Tue, 15 Jan 2013 16:24:38 -0800
Message-Id: <1358295894-24167-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-3620-0000-0000-000000E82E8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches that follow add a inline function zone_end_pfn(), which
conflicts with the naming of a local variable in isolate_freepages().

Rename the variable so it does not conflict.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/compaction.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c62bd06..1b52528 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -644,7 +644,7 @@ static void isolate_freepages(struct zone *zone,
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, zone_end_pfn, end_pfn;
+	unsigned long high_pfn, low_pfn, pfn, z_end_pfn, end_pfn;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -663,7 +663,7 @@ static void isolate_freepages(struct zone *zone,
 	 */
 	high_pfn = min(low_pfn, pfn);
 
-	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	z_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -706,7 +706,7 @@ static void isolate_freepages(struct zone *zone,
 		 * only scans within a pageblock
 		 */
 		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
-		end_pfn = min(end_pfn, zone_end_pfn);
+		end_pfn = min(end_pfn, z_end_pfn);
 		isolated = isolate_freepages_block(cc, pfn, end_pfn,
 						   freelist, false);
 		nr_freepages += isolated;
-- 
1.8.0.3


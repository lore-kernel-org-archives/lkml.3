Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3APA0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:26:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59996 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291Ab3APA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:03 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 17/17] mm/compaction: use zone_end_pfn()
Date: Tue, 15 Jan 2013 16:24:54 -0800
Message-Id: <1358295894-24167-18-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-7182-0000-0000-000004762F2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using zone_end_pfn from open coding.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/compaction.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1b52528..ea66be3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -85,7 +85,7 @@ static inline bool isolation_suitable(struct compact_control *cc,
 static void __reset_isolation_suitable(struct zone *zone)
 {
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
 	zone->compact_cached_migrate_pfn = start_pfn;
@@ -663,7 +663,7 @@ static void isolate_freepages(struct zone *zone,
 	 */
 	high_pfn = min(low_pfn, pfn);
 
-	z_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	z_end_pfn = zone_end_pfn(zone);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -920,7 +920,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 
 	ret = compaction_suitable(zone, cc->order);
 	switch (ret) {
-- 
1.8.0.3


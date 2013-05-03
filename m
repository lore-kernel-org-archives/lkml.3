Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3ECABs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:01:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41860 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762057Ab3ECABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:19 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 05/31] mm/memory_hotplug: use {pgdat,zone}_is_empty() when resizing zones & pgdats
Date: Thu,  2 May 2013 17:00:37 -0700
Message-Id: <1367539263-19999-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-3620-0000-0000-0000024F538B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the *_is_empty() helpers to be more clear about what we're actually
checking for.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f4cb01a..a65235f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -242,7 +242,7 @@ static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 	zone_span_writelock(zone);
 
 	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	if (!zone->spanned_pages || start_pfn < zone->zone_start_pfn)
+	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
 	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
@@ -383,7 +383,7 @@ static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 	unsigned long old_pgdat_end_pfn =
 		pgdat->node_start_pfn + pgdat->node_spanned_pages;
 
-	if (!pgdat->node_spanned_pages || start_pfn < pgdat->node_start_pfn)
+	if (pgdat_is_empty(pgdat) || start_pfn < pgdat->node_start_pfn)
 		pgdat->node_start_pfn = start_pfn;
 
 	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
-- 
1.8.2.2


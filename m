Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab3IEJKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:10:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10752 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763319Ab3IEJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:10:19 -0400
Message-ID: <52284A5E.7000306@huawei.com>
Date: Thu, 5 Sep 2013 17:09:50 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Liujiang <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm: use populated_zone() instead of if(zone->present_pages)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "if (zone->present_pages)" instead of "if (zone->present_pages)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..30ef67c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4195,7 +4195,7 @@ static __meminit void zone_pcp_init(struct zone *zone)
 	 */
 	zone->pageset = &boot_pageset;
 
-	if (zone->present_pages)
+	if (populated_zone(zone))
 		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
 			zone->name, zone->present_pages,
 					 zone_batchsize(zone));
@@ -5087,7 +5087,7 @@ static void check_for_memory(pg_data_t *pgdat, int nid)
 
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
-		if (zone->present_pages) {
+		if (populated_zone(zone)) {
 			node_set_state(nid, N_HIGH_MEMORY);
 			if (N_NORMAL_MEMORY != N_HIGH_MEMORY &&
 			    zone_type <= ZONE_NORMAL)
-- 
1.7.1



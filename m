Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3EQPqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:46:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61725 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3EQPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:46:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v7, part3 09/16] mm: use managed_pages to calculate default zonelist order
Date: Fri, 17 May 2013 23:45:11 +0800
Message-Id: <1368805518-2634-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
References: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use zone->managed_pages instead of zone->present_pages to calculate
default zonelist order because managed_pages means allocatable pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 88c8642..f7714c8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3451,8 +3451,8 @@ static int default_zonelist_order(void)
 			z = &NODE_DATA(nid)->node_zones[zone_type];
 			if (populated_zone(z)) {
 				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
+					low_kmem_size += z->managed_pages;
+				total_size += z->managed_pages;
 			} else if (zone_type == ZONE_NORMAL) {
 				/*
 				 * If any node has only lowmem, then node order
-- 
1.8.1.2


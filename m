Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3EHPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:19:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39186 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab3EHPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:19:35 -0400
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
Subject: [PATCH v5, part3 09/15] mm: use managed_pages to calculate default zonelist order
Date: Wed,  8 May 2013 23:17:08 +0800
Message-Id: <1368026235-5976-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368026235-5976-1-git-send-email-jiang.liu@huawei.com>
References: <1368026235-5976-1-git-send-email-jiang.liu@huawei.com>
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
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4a9ecd8..1b177bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3449,8 +3449,8 @@ static int default_zonelist_order(void)
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
1.7.9.5


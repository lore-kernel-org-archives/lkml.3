Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3DLBPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:15:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49828 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3DLBOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:51 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 23/25] mm/page_alloc: make pr_err() in page_outside_zone_boundaries() more useful
Date: Thu, 11 Apr 2013 18:13:55 -0700
Message-Id: <1365729237-29711-24-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-9360-0000-0000-000011B4F928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a54baa9..20304cb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -253,8 +253,11 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
-		pr_err("page %lu outside zone [ %lu - %lu ]\n",
-			pfn, start_pfn, start_pfn + sp);
+		pr_err("page with pfn %05lx outside zone %s with pfn range {%05lx-%05lx} in node %d with pfn range {%05lx-%05lx}\n",
+			pfn, zone->name, start_pfn, start_pfn + sp,
+			zone->zone_pgdat->node_id,
+			zone->zone_pgdat->node_start_pfn,
+			pgdat_end_pfn(zone->zone_pgdat));
 
 	return ret;
 }
-- 
1.8.2.1


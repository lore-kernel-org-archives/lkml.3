Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010Ab3ECAGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:06:01 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55431 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057Ab3ECABu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:50 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 29/31] mm/page_alloc: make pr_err() in page_outside_zone_boundaries() more useful
Date: Thu,  2 May 2013 17:01:01 -0700
Message-Id: <1367539263-19999-30-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684BA3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3695ca5..4fe35b24 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -254,8 +254,11 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
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
1.8.2.2


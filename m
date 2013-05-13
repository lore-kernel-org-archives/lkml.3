Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3EMTMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:12:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36542 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3EMTJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:09:17 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 11/11] mm/page_alloc: rename setup_pagelist_highmark() to match naming of pageset_set_batch()
Date: Mon, 13 May 2013 12:08:23 -0700
Message-Id: <1368472103-3427-12-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-7182-0000-0000-000006AB01F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 251fb5f..b335c98 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4063,7 +4063,7 @@ static void pageset_update(struct per_cpu_pages *pcp, unsigned long high,
 	pcp->batch = batch;
 }
 
-/* a companion to setup_pagelist_highmark() */
+/* a companion to pageset_set_high() */
 static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 {
 	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
@@ -4089,10 +4089,10 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 }
 
 /*
- * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
+ * pageset_set_high() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
  */
-static void setup_pagelist_highmark(struct per_cpu_pageset *p,
+static void pageset_set_high(struct per_cpu_pageset *p,
 				unsigned long high)
 {
 	unsigned long batch = max(1UL, high / 4);
@@ -4108,7 +4108,7 @@ static void __meminit zone_pageset_init(struct zone *zone, int cpu)
 
 	pageset_init(pcp);
 	if (percpu_pagelist_fraction)
-		setup_pagelist_highmark(pcp,
+		pageset_set_high(pcp,
 			(zone->managed_pages /
 				percpu_pagelist_fraction));
 	else
@@ -5597,8 +5597,8 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 		unsigned long  high;
 		high = zone->managed_pages / percpu_pagelist_fraction;
 		for_each_possible_cpu(cpu)
-			setup_pagelist_highmark(
-					per_cpu_ptr(zone->pageset, cpu), high);
+			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
+					 high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
-- 
1.8.2.2


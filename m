Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3EMTJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:09:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42826 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3EMTJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:09:02 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 07/11] mm/page_alloc: factor setup_pageset() into pageset_init() and pageset_set_batch()
Date: Mon, 13 May 2013 12:08:19 -0700
Message-Id: <1368472103-3427-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-3620-0000-0000-000002757305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3583281..696ce96 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4069,7 +4069,7 @@ static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
 }
 
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void pageset_init(struct per_cpu_pageset *p)
 {
 	struct per_cpu_pages *pcp;
 	int migratetype;
@@ -4078,11 +4078,16 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 
 	pcp = &p->pcp;
 	pcp->count = 0;
-	pageset_set_batch(p, batch);
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
 
+static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+{
+	pageset_init(p);
+	pageset_set_batch(p, batch);
+}
+
 /*
  * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
-- 
1.8.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936768Ab3DIX3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:29:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38916 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936664Ab3DIX2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:28:54 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 06/10] mm/page_alloc: factor setup_pageset() into pageset_init() and pageset_set_batch()
Date: Tue,  9 Apr 2013 16:28:15 -0700
Message-Id: <1365550099-6795-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365550099-6795-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040923-2398-0000-0000-0000131C8B21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 50a277a..a2f2207 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4030,7 +4030,7 @@ static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 	pcp->batch = max(1UL, 1 * batch);
 }
 
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void pageset_init(struct per_cpu_pageset *p)
 {
 	struct per_cpu_pages *pcp;
 	int migratetype;
@@ -4039,11 +4039,16 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 
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
1.8.2


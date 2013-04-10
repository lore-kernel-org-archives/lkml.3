Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab3DJS0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:26:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42663 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937188Ab3DJSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:24:36 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 07/11] mm/page_alloc: factor setup_pageset() into pageset_init() and pageset_set_batch()
Date: Wed, 10 Apr 2013 11:23:35 -0700
Message-Id: <1365618219-17154-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041018-5806-0000-0000-000020ACC206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3447a4b..352c279a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4043,7 +4043,7 @@ static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
 }
 
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void pageset_init(struct per_cpu_pageset *p)
 {
 	struct per_cpu_pages *pcp;
 	int migratetype;
@@ -4052,11 +4052,16 @@ static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 
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
1.8.2.1


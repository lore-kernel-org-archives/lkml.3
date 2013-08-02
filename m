Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3HBCIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:08:07 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62998 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3HBCIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:08:05 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-51-51fb148148de
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/4] mm: move pgtable related functions to right place
Date: Fri,  2 Aug 2013 11:07:58 +0900
Message-Id: <1375409279-16919-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pgtable related functions are mostly in pgtable-generic.c.
So move remaining functions from memory.c to pgtable-generic.c.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/memory.c b/mm/memory.c
index 1ce2e2a..26bce51 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -374,30 +374,6 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 /*
- * If a p?d_bad entry is found while walking page tables, report
- * the error, before resetting entry to p?d_none.  Usually (but
- * very seldom) called out from the p?d_none_or_clear_bad macros.
- */
-
-void pgd_clear_bad(pgd_t *pgd)
-{
-	pgd_ERROR(*pgd);
-	pgd_clear(pgd);
-}
-
-void pud_clear_bad(pud_t *pud)
-{
-	pud_ERROR(*pud);
-	pud_clear(pud);
-}
-
-void pmd_clear_bad(pmd_t *pmd)
-{
-	pmd_ERROR(*pmd);
-	pmd_clear(pmd);
-}
-
-/*
  * Note: this doesn't free the actual pages themselves. That
  * has been handled earlier when unmapping all the memory regions.
  */
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index e1a6e4f..3929a40 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -10,6 +10,30 @@
 #include <asm/tlb.h>
 #include <asm-generic/pgtable.h>
 
+/*
+ * If a p?d_bad entry is found while walking page tables, report
+ * the error, before resetting entry to p?d_none.  Usually (but
+ * very seldom) called out from the p?d_none_or_clear_bad macros.
+ */
+
+void pgd_clear_bad(pgd_t *pgd)
+{
+	pgd_ERROR(*pgd);
+	pgd_clear(pgd);
+}
+
+void pud_clear_bad(pud_t *pud)
+{
+	pud_ERROR(*pud);
+	pud_clear(pud);
+}
+
+void pmd_clear_bad(pmd_t *pmd)
+{
+	pmd_ERROR(*pmd);
+	pmd_clear(pmd);
+}
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Only sets the access flags (dirty, accessed), as well as write 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3I0N2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:28:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3I0N14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:27:56 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 03/63] sched, numa: Comment fixlets
Date: Fri, 27 Sep 2013 14:26:48 +0100
Message-Id: <1380288468-5551-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Fix a 80 column violation and a PTE vs PMD reference.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 8 ++++----
 mm/huge_memory.c    | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f238d49..a5d5b1e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -988,10 +988,10 @@ void task_numa_work(struct callback_head *work)
 
 out:
 	/*
-	 * It is possible to reach the end of the VMA list but the last few VMAs are
-	 * not guaranteed to the vma_migratable. If they are not, we would find the
-	 * !migratable VMA on the next scan but not reset the scanner to the start
-	 * so check it now.
+	 * It is possible to reach the end of the VMA list but the last few
+	 * VMAs are not guaranteed to the vma_migratable. If they are not, we
+	 * would find the !migratable VMA on the next scan but not reset the
+	 * scanner to the start so check it now.
 	 */
 	if (vma)
 		mm->numa_scan_offset = start;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a92012a..860a368 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1317,7 +1317,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(&mm->page_table_lock);
 	lock_page(page);
 
-	/* Confirm the PTE did not while locked */
+	/* Confirm the PMD did not change while page_table_lock was released */
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);
-- 
1.8.1.4


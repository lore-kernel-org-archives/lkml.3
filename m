Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3JIRZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:25:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3JIRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:25:04 -0400
Date: Wed, 9 Oct 2013 10:24:23 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c69307d533d7aa7cc8894dbbb8a274599f8630d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-4-git-send-email-mgorman@suse.de>
References: <1381141781-10992-4-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix comments
Git-Commit-ID: c69307d533d7aa7cc8894dbbb8a274599f8630d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:24:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c69307d533d7aa7cc8894dbbb8a274599f8630d7
Gitweb:     http://git.kernel.org/tip/c69307d533d7aa7cc8894dbbb8a274599f8630d7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 7 Oct 2013 11:28:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:30 +0200

sched/numa: Fix comments

Fix a 80 column violation and a PTE vs PMD reference.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1381141781-10992-4-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 mm/huge_memory.c    | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2b89cd2..817cd7b 100644
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
index 7489884..19dbb08 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1305,7 +1305,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(&mm->page_table_lock);
 	lock_page(page);
 
-	/* Confirm the PTE did not while locked */
+	/* Confirm the PMD did not change while page_table_lock was released */
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);

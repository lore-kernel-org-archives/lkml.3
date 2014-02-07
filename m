Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaBGMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:03:18 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35410 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaBGMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:03:15 -0500
Date: Fri, 7 Feb 2014 17:33:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, josh@joshtriplett.org
Subject: [PATCH 2/9] mm: Mark functions as static in memory.c
Message-ID: <2bd9a806eae6958a75de452ba1d09f5cb6e2f7bc.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in memory.c because they are not used outside
this file.

This eliminates the following warnings in mm/memory.c:
mm/memory.c:3530:5: warning: no previous prototype for ‘numa_migrate_prep’ [-Wmissing-prototypes]
mm/memory.c:3545:5: warning: no previous prototype for ‘do_numa_page’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5d9025f..982c1ad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3527,7 +3527,7 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 				unsigned long addr, int page_nid,
 				int *flags)
 {
@@ -3542,7 +3542,7 @@ int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 	return mpol_misplaced(page, vma, addr);
 }
 
-int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		   unsigned long addr, pte_t pte, pte_t *ptep, pmd_t *pmd)
 {
 	struct page *page = NULL;
-- 
1.7.9.5


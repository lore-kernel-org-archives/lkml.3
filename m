Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaHAUTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbaHAUTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:19:14 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH -mm v6 07/13] numa_maps: fix typo in gather_hugetbl_stats
Date: Fri,  1 Aug 2014 15:20:43 -0400
Message-Id: <1406920849-25908-8-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just doing s/gather_hugetbl_stats/gather_hugetlb_stats/g, this makes code
grep-friendly.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/task_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git mmotm-2014-07-30-15-57.orig/fs/proc/task_mmu.c mmotm-2014-07-30-15-57/fs/proc/task_mmu.c
index e4c6cdb9647b..8b1eb1617445 100644
--- mmotm-2014-07-30-15-57.orig/fs/proc/task_mmu.c
+++ mmotm-2014-07-30-15-57/fs/proc/task_mmu.c
@@ -1340,7 +1340,7 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	struct numa_maps *md;
@@ -1359,7 +1359,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 }
 
 #else
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	return 0;
@@ -1391,7 +1391,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 
 	md->vma = vma;
 
-	walk.hugetlb_entry = gather_hugetbl_stats;
+	walk.hugetlb_entry = gather_hugetlb_stats;
 	walk.pmd_entry = gather_pte_stats;
 	walk.private = md;
 	walk.mm = mm;
-- 
1.9.3


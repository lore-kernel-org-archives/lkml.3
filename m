Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3FNJcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:32:39 -0400
Received: from multi.imgtec.com ([194.200.65.239]:28325 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab3FNJci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:32:38 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: [PATCH] metag: fix mm/hugetlb.c build breakage
Date: Fri, 14 Jun 2013 10:31:01 +0100
Message-ID: <1371202261-30931-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_14_10_32_36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 106c992a5ebef28193cf5958e49ceff5e4aebb04 ("mm/hugetlb: add more
arch-defined huge_pte functions") merged in v3.10-rc1.

The above commit added an include of <asm-generic/hugetlb.h> to each
architecture's <asm/hugetlb.h> (except s390). Unfortunately metag was
missed which resulted in build errors when hugetlbfs is enabled (see
below). Add the include for metag too to fix the build errors.

mm/hugetlb.c In function 'make_huge_pte':
mm/hugetlb.c +2250 : error: implicit declaration of function 'huge_pte_mkwrite'
mm/hugetlb.c +2250 : error: implicit declaration of function 'huge_pte_mkdirty'
mm/hugetlb.c +2250 : error: implicit declaration of function 'mk_huge_pte'
mm/hugetlb.c +2251 : error: incompatible types in assignment
mm/hugetlb.c +2254 : error: incompatible type for argument 1 of 'huge_pte_wrprotect'
mm/hugetlb.c In function 'set_huge_ptep_writable':
mm/hugetlb.c +2268 : error: incompatible types in assignment
mm/hugetlb.c In function '__unmap_hugepage_range':
mm/hugetlb.c +2383 : error: implicit declaration of function 'huge_pte_clear'
mm/hugetlb.c +2407 : error: implicit declaration of function 'huge_pte_dirty'
mm/hugetlb.c In function 'hugetlb_fault':
mm/hugetlb.c +2860 : error: implicit declaration of function 'huge_pte_write'
mm/hugetlb.c +2895 : error: incompatible types in assignment
mm/hugetlb.c In function 'hugetlb_change_protection':
mm/hugetlb.c +3047 : error: implicit declaration of function 'huge_pte_modify'
mm/hugetlb.c +3047 : error: incompatible type for argument 1 of 'pte_mkhuge'
make[1]: *** [mm/hugetlb.o] Error 1
make: *** [mm/hugetlb.o] Error 2

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 arch/metag/include/asm/hugetlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/metag/include/asm/hugetlb.h b/arch/metag/include/asm/hugetlb.h
index f545477..471f481 100644
--- a/arch/metag/include/asm/hugetlb.h
+++ b/arch/metag/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_METAG_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
-- 
1.8.1.2



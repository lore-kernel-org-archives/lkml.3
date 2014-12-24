Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaLXM0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:26:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:24591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaLXMXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376413"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 36/38] unicore32: drop pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:44 +0200
Message-Id: <1419423766-114457-37-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/pgtable-hwdef.h |  1 -
 arch/unicore32/include/asm/pgtable.h       | 14 --------------
 2 files changed, 15 deletions(-)

diff --git a/arch/unicore32/include/asm/pgtable-hwdef.h b/arch/unicore32/include/asm/pgtable-hwdef.h
index 7314e859cca0..e37fa471c2be 100644
--- a/arch/unicore32/include/asm/pgtable-hwdef.h
+++ b/arch/unicore32/include/asm/pgtable-hwdef.h
@@ -44,7 +44,6 @@
 #define PTE_TYPE_INVALID	(3 << 0)
 
 #define PTE_PRESENT		(1 << 2)
-#define PTE_FILE		(1 << 3)	/* only when !PRESENT */
 #define PTE_YOUNG		(1 << 3)
 #define PTE_DIRTY		(1 << 4)
 #define PTE_CACHEABLE		(1 << 5)
diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
index ed6f7d000fba..818d0f5598e3 100644
--- a/arch/unicore32/include/asm/pgtable.h
+++ b/arch/unicore32/include/asm/pgtable.h
@@ -283,20 +283,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 #define MAX_SWAPFILES_CHECK()	\
 	BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
 
-/*
- * Encode and decode a file entry.  File entries are stored in the Linux
- * page tables as follows:
- *
- *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
- *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   <----------------------- offset ----------------------> 1 0 0 0
- */
-#define pte_file(pte)		(pte_val(pte) & PTE_FILE)
-#define pte_to_pgoff(x)		(pte_val(x) >> 4)
-#define pgoff_to_pte(x)		__pte(((x) << 4) | PTE_FILE)
-
-#define PTE_FILE_MAX_BITS	28
-
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 /* FIXME: this is not correct */
 #define kern_addr_valid(addr)	(1)
-- 
2.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaLXMdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:33:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:42326 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaLXMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669809"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 09/38] alpha: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:17 +0200
Message-Id: <1419423766-114457-10-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/pgtable.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
index d8f9b7e89234..fce22cf88ee9 100644
--- a/arch/alpha/include/asm/pgtable.h
+++ b/arch/alpha/include/asm/pgtable.h
@@ -73,7 +73,6 @@ struct vm_area_struct;
 /* .. and these are ours ... */
 #define _PAGE_DIRTY	0x20000
 #define _PAGE_ACCESSED	0x40000
-#define _PAGE_FILE	0x80000	/* set:pagecache, unset:swap */
 
 /*
  * NOTE! The "accessed" bit isn't necessarily exact:  it can be kept exactly
@@ -268,7 +267,6 @@ extern inline void pgd_clear(pgd_t * pgdp)	{ pgd_val(*pgdp) = 0; }
 extern inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_FOW); }
 extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 extern inline int pte_special(pte_t pte)	{ return 0; }
 
 extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOW; return pte; }
@@ -345,11 +343,6 @@ extern inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 32)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 32) | _PAGE_FILE })
-
-#define PTE_FILE_MAX_BITS	32
-
 #ifndef CONFIG_DISCONTIGMEM
 #define kern_addr_valid(addr)	(1)
 #endif
-- 
2.1.3


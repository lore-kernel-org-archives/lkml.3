Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaDYIWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:22:38 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40825 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaDYIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:20:46 -0400
Message-Id: <20140425082042.737179159@openvz.org>
User-Agent: quilt/0.60-1
Date: Fri, 25 Apr 2014 12:10:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org, mgorman@suse.de,
        hpa@zytor.com, mingo@kernel.org, steven@uplinklabs.net,
        riel@redhat.com, david.vrabel@citrix.com, akpm@linux-foundation.org,
        peterz@infradead.org, xemul@parallels.com, gorcunov@openvz.org
Subject: [patch 1/2] mm: pgtable -- Drop unneeded preprocessor ifdef
References: <20140425081030.185969086@openvz.org>
Content-Disposition: inline; filename=pgbits-drop-if
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_BIT_FILE (bit 6) is always less than _PAGE_BIT_PROTNONE (bit 8),
so drop redundant #ifdef.

CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>
CC: Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Steven Noonan <steven@uplinklabs.net>
CC: Rik van Riel <riel@redhat.com>
CC: David Vrabel <david.vrabel@citrix.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/pgtable-2level.h |   10 ----------
 arch/x86/include/asm/pgtable_64.h     |    8 --------
 2 files changed, 18 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/pgtable-2level.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/pgtable-2level.h
+++ linux-2.6.git/arch/x86/include/asm/pgtable-2level.h
@@ -115,13 +115,8 @@ static __always_inline pte_t pgoff_to_pt
  */
 #define PTE_FILE_MAX_BITS	29
 #define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
 #define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
-#else
-#define PTE_FILE_SHIFT2		(_PAGE_BIT_PROTNONE + 1)
-#define PTE_FILE_SHIFT3		(_PAGE_BIT_FILE + 1)
-#endif
 #define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
@@ -153,13 +148,8 @@ static __always_inline pte_t pgoff_to_pt
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
 /* Encode and de-code a swap entry */
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
-#else
-#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
-#endif
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 
Index: linux-2.6.git/arch/x86/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/pgtable_64.h
+++ linux-2.6.git/arch/x86/include/asm/pgtable_64.h
@@ -143,7 +143,6 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
 /* Encode and de-code a swap entry */
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
 #ifdef CONFIG_NUMA_BALANCING
 /* Automatic NUMA balancing needs to be distinguishable from swap entries */
@@ -151,13 +150,6 @@ static inline int pgd_large(pgd_t pgd) {
 #else
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
 #endif
-#else
-#ifdef CONFIG_NUMA_BALANCING
-#error Incompatible format for automatic NUMA balancing
-#endif
-#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
-#endif
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 


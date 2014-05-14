Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaENTBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:48 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62420 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaENTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 17/27] mn10300: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:49 +0200
Message-Id: <1400093999-18703-18-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-am33-list@redhat.com
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mn10300/include/asm/Kbuild    |  1 +
 arch/mn10300/include/asm/pgalloc.h |  2 ++
 arch/mn10300/include/asm/tlb.h     | 34 ----------------------------------
 3 files changed, 3 insertions(+), 34 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/tlb.h

diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 654d5ba..ecfaa34 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -6,4 +6,5 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += tlb.h
 generic-y += trace_clock.h
diff --git a/arch/mn10300/include/asm/pgalloc.h b/arch/mn10300/include/asm/pgalloc.h
index 0f25d5f..0027581 100644
--- a/arch/mn10300/include/asm/pgalloc.h
+++ b/arch/mn10300/include/asm/pgalloc.h
@@ -53,4 +53,6 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte)
 
 #define __pte_free_tlb(tlb, pte, addr) tlb_remove_page((tlb), (pte))
 
+extern void check_pgt_cache(void);
+
 #endif /* _ASM_PGALLOC_H */
diff --git a/arch/mn10300/include/asm/tlb.h b/arch/mn10300/include/asm/tlb.h
deleted file mode 100644
index 65d232b..0000000
--- a/arch/mn10300/include/asm/tlb.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* MN10300 TLB definitions
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _ASM_TLB_H
-#define _ASM_TLB_H
-
-#include <asm/tlbflush.h>
-
-extern void check_pgt_cache(void);
-
-/*
- * we don't need any special per-pte or per-vma handling...
- */
-#define tlb_start_vma(tlb, vma)				do { } while (0)
-#define tlb_end_vma(tlb, vma)				do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
-
-/*
- * .. because we flush the whole mm when it fills up
- */
-#define tlb_flush(tlb)	flush_tlb_mm((tlb)->mm)
-
-/* for now, just use the generic stuff */
-#include <asm-generic/tlb.h>
-
-#endif /* _ASM_TLB_H */
-- 
1.8.4.2


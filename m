Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaENTCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:02:07 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62424 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaENTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:02:03 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 21/27] score: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:53 +0200
Message-Id: <1400093999-18703-22-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/score/include/asm/Kbuild |  1 +
 arch/score/include/asm/irq.h  |  1 +
 arch/score/include/asm/tlb.h  | 17 -----------------
 3 files changed, 2 insertions(+), 17 deletions(-)
 delete mode 100644 arch/score/include/asm/tlb.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 2f947ab..fee1a34 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -8,5 +8,6 @@ generic-y += cputime.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += tlb.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
index c883f3d..c5ea32a 100644
--- a/arch/score/include/asm/irq.h
+++ b/arch/score/include/asm/irq.h
@@ -21,5 +21,6 @@
 #define IRQ_TIMER (7)		/* Timer IRQ number of SPCT6600 */
 
 extern void interrupt_exception_vector(void);
+extern void score7_FTLB_refill_Handler(void);
 
 #endif /* _ASM_SCORE_IRQ_H */
diff --git a/arch/score/include/asm/tlb.h b/arch/score/include/asm/tlb.h
deleted file mode 100644
index 46882ed..0000000
--- a/arch/score/include/asm/tlb.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_SCORE_TLB_H
-#define _ASM_SCORE_TLB_H
-
-/*
- * SCORE doesn't need any special per-pte or per-vma handling, except
- * we need to flush cache for area to be unmapped.
- */
-#define tlb_start_vma(tlb, vma)		do {} while (0)
-#define tlb_end_vma(tlb, vma)		do {} while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do {} while (0)
-#define tlb_flush(tlb)			flush_tlb_mm((tlb)->mm)
-
-extern void score7_FTLB_refill_Handler(void);
-
-#include <asm-generic/tlb.h>
-
-#endif /* _ASM_SCORE_TLB_H */
-- 
1.8.4.2


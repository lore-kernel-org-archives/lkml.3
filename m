Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaENTBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:11 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaENTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH 04/27] alpha: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:36 +0200
Message-Id: <1400093999-18703-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/alpha/include/asm/Kbuild |  1 +
 arch/alpha/include/asm/tlb.h  | 15 ---------------
 2 files changed, 1 insertion(+), 15 deletions(-)
 delete mode 100644 arch/alpha/include/asm/tlb.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 96e54be..459aa4c 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -6,4 +6,5 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += tlb.h
 generic-y += trace_clock.h
diff --git a/arch/alpha/include/asm/tlb.h b/arch/alpha/include/asm/tlb.h
deleted file mode 100644
index 4286675..0000000
--- a/arch/alpha/include/asm/tlb.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ALPHA_TLB_H
-#define _ALPHA_TLB_H
-
-#define tlb_start_vma(tlb, vma)			do { } while (0)
-#define tlb_end_vma(tlb, vma)			do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, pte, addr)	do { } while (0)
-
-#define tlb_flush(tlb)				flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#define __pte_free_tlb(tlb, pte, address)		pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, address)		pmd_free((tlb)->mm, pmd)
- 
-#endif
-- 
1.8.4.2


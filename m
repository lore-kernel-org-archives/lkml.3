Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaENTBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:34 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62415 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaENTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org
Subject: [PATCH 12/27] m32r: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:44 +0200
Message-Id: <1400093999-18703-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-m32r@ml.linux-m32r.org
Cc: linux-m32r-ja@ml.linux-m32r.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m32r/include/asm/Kbuild |  1 +
 arch/m32r/include/asm/tlb.h  | 20 --------------------
 2 files changed, 1 insertion(+), 20 deletions(-)
 delete mode 100644 arch/m32r/include/asm/tlb.h

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 67779a7..2cc845b 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -6,4 +6,5 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
+generic-y += tlb.h
 generic-y += trace_clock.h
diff --git a/arch/m32r/include/asm/tlb.h b/arch/m32r/include/asm/tlb.h
deleted file mode 100644
index c7ebd8d..0000000
--- a/arch/m32r/include/asm/tlb.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _M32R_TLB_H
-#define _M32R_TLB_H
-
-/*
- * x86 doesn't need any special per-pte or
- * per-vma handling..
- */
-#define tlb_start_vma(tlb, vma) do { } while (0)
-#define tlb_end_vma(tlb, vma) do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, pte, address) do { } while (0)
-
-/*
- * .. because we flush the whole mm when it
- * fills up.
- */
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#endif /* _M32R_TLB_H */
-- 
1.8.4.2


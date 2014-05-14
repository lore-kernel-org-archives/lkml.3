Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaENTBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:21 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62411 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaENTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:20 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 08/27] c6x: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:40 +0200
Message-Id: <1400093999-18703-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/c6x/include/asm/Kbuild | 1 +
 arch/c6x/include/asm/tlb.h  | 8 --------
 2 files changed, 1 insertion(+), 8 deletions(-)
 delete mode 100644 arch/c6x/include/asm/tlb.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 8dbdce8..3a41af2 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -51,6 +51,7 @@ generic-y += stat.h
 generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += tlb.h
 generic-y += tlbflush.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/c6x/include/asm/tlb.h b/arch/c6x/include/asm/tlb.h
deleted file mode 100644
index 8709e5e..0000000
--- a/arch/c6x/include/asm/tlb.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_C6X_TLB_H
-#define _ASM_C6X_TLB_H
-
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#endif /* _ASM_C6X_TLB_H */
-- 
1.8.4.2


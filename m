Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaENTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:59 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62422 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:57 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Jonas Bonn <jonas@southpole.se>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux@openrisc.net
Subject: [PATCH 18/27] openrisc: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:50 +0200
Message-Id: <1400093999-18703-19-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Jonas Bonn <jonas@southpole.se>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux@lists.openrisc.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/include/asm/Kbuild |  1 +
 arch/openrisc/include/asm/tlb.h  | 34 ----------------------------------
 2 files changed, 1 insertion(+), 34 deletions(-)
 delete mode 100644 arch/openrisc/include/asm/tlb.h

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 480af0d..abe411f 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -63,6 +63,7 @@ generic-y += swab.h
 generic-y += switch_to.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += tlb.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += types.h
diff --git a/arch/openrisc/include/asm/tlb.h b/arch/openrisc/include/asm/tlb.h
deleted file mode 100644
index fa4376a..0000000
--- a/arch/openrisc/include/asm/tlb.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_TLB_H__
-#define __ASM_OPENRISC_TLB_H__
-
-/*
- * or32 doesn't need any special per-pte or
- * per-vma handling..
- */
-#define tlb_start_vma(tlb, vma) do { } while (0)
-#define tlb_end_vma(tlb, vma) do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
-
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
-#include <linux/pagemap.h>
-#include <asm-generic/tlb.h>
-
-#endif /* __ASM_OPENRISC_TLB_H__ */
-- 
1.8.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaENTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:32 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62414 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaENTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Richard Kuo <rkuo@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chen Gang <gang.chen.5i5j@gmail.com>, linux-hexagon@vger.kernel.org
Subject: [PATCH 11/27] hexagon: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:43 +0200
Message-Id: <1400093999-18703-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/hexagon/include/asm/Kbuild |  1 +
 arch/hexagon/include/asm/tlb.h  | 39 ---------------------------------------
 2 files changed, 1 insertion(+), 39 deletions(-)
 delete mode 100644 arch/hexagon/include/asm/tlb.h

diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 0e69796..7397e1a 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -52,6 +52,7 @@ generic-y += stat.h
 generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += tlb.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += types.h
diff --git a/arch/hexagon/include/asm/tlb.h b/arch/hexagon/include/asm/tlb.h
deleted file mode 100644
index 2f00772..0000000
--- a/arch/hexagon/include/asm/tlb.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef _ASM_TLB_H
-#define _ASM_TLB_H
-
-#include <linux/pagemap.h>
-#include <asm/tlbflush.h>
-
-/*
- * We don't need any special per-pte or per-vma handling...
- */
-#define tlb_start_vma(tlb, vma)				do { } while (0)
-#define tlb_end_vma(tlb, vma)				do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
-
-/*
- * .. because we flush the whole mm when it fills up
- */
-#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#endif
-- 
1.8.4.2


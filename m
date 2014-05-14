Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaENTD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:03:56 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62424 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaENTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:02:05 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, Tony Lu <zlu@tilera.com>
Subject: [PATCH 24/27] tile: Use generic tlb.h
Date: Wed, 14 May 2014 20:59:56 +0200
Message-Id: <1400093999-18703-25-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everything we need is now in generic tlb.h
we can drop our own one.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tony Lu <zlu@tilera.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/tile/include/asm/Kbuild |  1 +
 arch/tile/include/asm/tlb.h  | 25 -------------------------
 2 files changed, 1 insertion(+), 25 deletions(-)
 delete mode 100644 arch/tile/include/asm/tlb.h

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 0aa5675..a4fabe4 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -38,6 +38,7 @@ generic-y += sockios.h
 generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += tlb.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
diff --git a/arch/tile/include/asm/tlb.h b/arch/tile/include/asm/tlb.h
deleted file mode 100644
index 4a891a1..0000000
--- a/arch/tile/include/asm/tlb.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_TLB_H
-#define _ASM_TILE_TLB_H
-
-#define tlb_start_vma(tlb, vma) do { } while (0)
-#define tlb_end_vma(tlb, vma) do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#endif /* _ASM_TILE_TLB_H */
-- 
1.8.4.2


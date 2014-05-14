Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaENTBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:30 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62416 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaENTB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:27 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 13/27] m68k: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:45 +0200
Message-Id: <1400093999-18703-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m68k/include/asm/tlb.h | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/m68k/include/asm/tlb.h b/arch/m68k/include/asm/tlb.h
index 1785cff..74c15f6 100644
--- a/arch/m68k/include/asm/tlb.h
+++ b/arch/m68k/include/asm/tlb.h
@@ -1,19 +1,11 @@
 #ifndef _M68K_TLB_H
 #define _M68K_TLB_H
 
-/*
- * m68k doesn't need any special per-pte or
- * per-vma handling..
- */
-#define tlb_start_vma(tlb, vma)	do { } while (0)
-#define tlb_end_vma(tlb, vma)	do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
-
-/*
- * .. because we flush the whole mm when it
- * fills up.
- */
-#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
+#ifdef CONFIG_MMU && !defined(CONFIG_COLDFIRE) && !defined(CONFIG_SUN3)
+/* These defines are needed to override the defaults from asm-generic/tlb.h */
+#define __pte_free_tlb __pte_free_tlb
+#define __pmd_free_tlb __pmd_free_tlb
+#endif
 
 #include <asm-generic/tlb.h>
 
-- 
1.8.4.2


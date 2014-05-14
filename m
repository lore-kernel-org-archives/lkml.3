Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaENTBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:37 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62412 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaENTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:25 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, David Howells <dhowells@redhat.com>
Subject: [PATCH 10/27] frv: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:42 +0200
Message-Id: <1400093999-18703-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: David Howells <dhowells@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/frv/include/asm/tlb.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/frv/include/asm/tlb.h b/arch/frv/include/asm/tlb.h
index cd458eb..ba690cc 100644
--- a/arch/frv/include/asm/tlb.h
+++ b/arch/frv/include/asm/tlb.h
@@ -9,18 +9,6 @@ extern void check_pgt_cache(void);
 #define check_pgt_cache() do {} while(0)
 #endif
 
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
-#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
-
 #include <asm-generic/tlb.h>
 
 #endif /* _ASM_TLB_H */
-- 
1.8.4.2


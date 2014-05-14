Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaENTB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:28 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62417 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaENTB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:27 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, James Hogan <james.hogan@imgtec.com>,
        linux-metag@vger.kernel.org
Subject: [PATCH 14/27] metag: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:46 +0200
Message-Id: <1400093999-18703-15-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: James Hogan <james.hogan@imgtec.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-metag@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/metag/include/asm/tlb.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/metag/include/asm/tlb.h b/arch/metag/include/asm/tlb.h
index 048282f1..0fb0b46 100644
--- a/arch/metag/include/asm/tlb.h
+++ b/arch/metag/include/asm/tlb.h
@@ -19,18 +19,8 @@
 		if (!tlb->fullmm)					      \
 			flush_tlb_range(vma, vma->vm_start, vma->vm_end);     \
 	} while (0)
-
-
-#else
-
-#define tlb_start_vma(tlb, vma)			do { } while (0)
-#define tlb_end_vma(tlb, vma)			do { } while (0)
-
 #endif
 
-#define __tlb_remove_tlb_entry(tlb, pte, addr)	do { } while (0)
-#define tlb_flush(tlb)				flush_tlb_mm((tlb)->mm)
-
 #include <asm-generic/tlb.h>
 
 #endif
-- 
1.8.4.2


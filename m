Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaENTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:46 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62421 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaENTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH 19/27] parisc: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:51 +0200
Message-Id: <1400093999-18703-20-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/parisc/include/asm/tlb.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/parisc/include/asm/tlb.h b/arch/parisc/include/asm/tlb.h
index 0792490..4e231b1 100644
--- a/arch/parisc/include/asm/tlb.h
+++ b/arch/parisc/include/asm/tlb.h
@@ -16,12 +16,6 @@ do {	if (!(tlb)->fullmm)	\
 		flush_tlb_range(vma, vma->vm_start, vma->vm_end); \
 } while (0)
 
-#define __tlb_remove_tlb_entry(tlb, pte, address) \
-	do { } while (0)
-
 #include <asm-generic/tlb.h>
 
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
-
 #endif
-- 
1.8.4.2


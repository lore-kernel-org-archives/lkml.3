Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaENTBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:01:13 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaENTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:01:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 05/27] arc: Use common bits from generic tlb.h
Date: Wed, 14 May 2014 20:59:37 +0200
Message-Id: <1400093999-18703-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1400093999-18703-1-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to define them on our own.

Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arc/include/asm/tlb.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arc/include/asm/tlb.h b/arch/arc/include/asm/tlb.h
index a9db5f6..a0fa06d 100644
--- a/arch/arc/include/asm/tlb.h
+++ b/arch/arc/include/asm/tlb.h
@@ -23,9 +23,7 @@ do {						\
  *
  * Note, read http://lkml.org/lkml/2004/1/15/6
  */
-#ifndef CONFIG_ARC_CACHE_VIPT_ALIASING
-#define tlb_start_vma(tlb, vma)
-#else
+#ifdef CONFIG_ARC_CACHE_VIPT_ALIASING
 #define tlb_start_vma(tlb, vma)						\
 do {									\
 	if (!tlb->fullmm)						\
@@ -39,8 +37,6 @@ do {									\
 		flush_tlb_range(vma, vma->vm_start, vma->vm_end);	\
 } while (0)
 
-#define __tlb_remove_tlb_entry(tlb, ptep, address)
-
 #include <linux/pagemap.h>
 #include <asm-generic/tlb.h>
 
-- 
1.8.4.2


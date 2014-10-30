Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaJ3NIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:08:11 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58342 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbaJ3NII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:08:08 -0400
From: Isamu Mogi <isamu@leafytree.jp>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        isamu@leafytree.jp
Subject: [PATCH v2 1/3] MIPS: R3000: Fix debug output for Virtual page number
Date: Thu, 30 Oct 2014 22:07:36 +0900
Message-Id: <1414674458-7583-2-git-send-email-isamu@leafytree.jp>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
 <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtual page number of R3000 in entryhi is 20 bit from MSB. But in
dump_tlb(), the bit mask to read it from entryhi is 19 bit (0xffffe000).
The patch fixes that to 0xfffff000.

Signed-off-by: Isamu Mogi <isamu@leafytree.jp>
---
 arch/mips/lib/r3k_dump_tlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lib/r3k_dump_tlb.c b/arch/mips/lib/r3k_dump_tlb.c
index 91615c2..1ef365a 100644
--- a/arch/mips/lib/r3k_dump_tlb.c
+++ b/arch/mips/lib/r3k_dump_tlb.c
@@ -34,7 +34,7 @@ static void dump_tlb(int first, int last)
 		entrylo0 = read_c0_entrylo0();
 
 		/* Unused entries have a virtual address of KSEG0.  */
-		if ((entryhi & 0xffffe000) != 0x80000000
+		if ((entryhi & 0xfffff000) != 0x80000000
 		    && (entryhi & 0xfc0) == asid) {
 			/*
 			 * Only print entries in use
@@ -43,7 +43,7 @@ static void dump_tlb(int first, int last)
 
 			printk("va=%08lx asid=%08lx"
 			       "  [pa=%06lx n=%d d=%d v=%d g=%d]",
-			       (entryhi & 0xffffe000),
+			       (entryhi & 0xfffff000),
 			       entryhi & 0xfc0,
 			       entrylo0 & PAGE_MASK,
 			       (entrylo0 & (1 << 11)) ? 1 : 0,
-- 
1.9.1


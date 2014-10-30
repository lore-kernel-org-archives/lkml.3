Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbaJ3NI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:08:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41189 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbaJ3NIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:08:10 -0400
From: Isamu Mogi <isamu@leafytree.jp>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        isamu@leafytree.jp
Subject: [PATCH v2 2/3] MIPS: R3000: Replace magic numbers with macros
Date: Thu, 30 Oct 2014 22:07:37 +0900
Message-Id: <1414674458-7583-3-git-send-email-isamu@leafytree.jp>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
References: <1410278429-8541-1-git-send-email-isamu@leafytree.jp>
 <1414674458-7583-1-git-send-email-isamu@leafytree.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also include asm/mmu_context.h for ASID_MASK.

Signed-off-by: Isamu Mogi <isamu@leafytree.jp>
---
 arch/mips/lib/r3k_dump_tlb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/mips/lib/r3k_dump_tlb.c b/arch/mips/lib/r3k_dump_tlb.c
index 1ef365a..c97bb70 100644
--- a/arch/mips/lib/r3k_dump_tlb.c
+++ b/arch/mips/lib/r3k_dump_tlb.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 
 #include <asm/mipsregs.h>
+#include <asm/mmu_context.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbdebug.h>
@@ -21,7 +22,7 @@ static void dump_tlb(int first, int last)
 	unsigned int asid;
 	unsigned long entryhi, entrylo0;
 
-	asid = read_c0_entryhi() & 0xfc0;
+	asid = read_c0_entryhi() & ASID_MASK;
 
 	for (i = first; i <= last; i++) {
 		write_c0_index(i<<8);
@@ -34,8 +35,8 @@ static void dump_tlb(int first, int last)
 		entrylo0 = read_c0_entrylo0();
 
 		/* Unused entries have a virtual address of KSEG0.  */
-		if ((entryhi & 0xfffff000) != 0x80000000
-		    && (entryhi & 0xfc0) == asid) {
+		if ((entryhi & PAGE_MASK) != KSEG0
+		    && (entryhi & ASID_MASK) == asid) {
 			/*
 			 * Only print entries in use
 			 */
@@ -43,8 +44,8 @@ static void dump_tlb(int first, int last)
 
 			printk("va=%08lx asid=%08lx"
 			       "  [pa=%06lx n=%d d=%d v=%d g=%d]",
-			       (entryhi & 0xfffff000),
-			       entryhi & 0xfc0,
+			       (entryhi & PAGE_MASK),
+			       entryhi & ASID_MASK,
 			       entrylo0 & PAGE_MASK,
 			       (entrylo0 & (1 << 11)) ? 1 : 0,
 			       (entrylo0 & (1 << 10)) ? 1 : 0,
-- 
1.9.1


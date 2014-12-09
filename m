Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaLIM0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:26:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60070 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbaLIM0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:26:05 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Unify segment selector defines
Date: Tue,  9 Dec 2014 13:25:59 +0100
Message-Id: <1418127959-29902-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Those are identical on 32- and 64-bit, unify them. No functional change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/segment.h | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 6f1c3a8a33ab..db257a58571f 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -23,6 +23,15 @@
 #define GDT_ENTRY_BOOT_TSS	(GDT_ENTRY_BOOT_CS + 2)
 #define __BOOT_TSS		(GDT_ENTRY_BOOT_TSS * 8)
 
+#define SEGMENT_RPL_MASK	0x3 /*
+				     * Bottom two bits of selector give the ring
+				     * privilege level
+				     */
+#define SEGMENT_TI_MASK		0x4 /* Bit 2 is table indicator (LDT/GDT) */
+#define USER_RPL		0x3 /* User mode is privilege level 3 */
+#define SEGMENT_LDT		0x4 /* LDT segment has TI set... */
+#define SEGMENT_GDT		0x0 /* ... GDT has it cleared */
+
 #ifdef CONFIG_X86_32
 /*
  * The layout of the per-CPU GDT under Linux:
@@ -125,16 +134,6 @@
 #define PNP_TS1    (GDT_ENTRY_PNPBIOS_TS1 * 8)	/* transfer data segment */
 #define PNP_TS2    (GDT_ENTRY_PNPBIOS_TS2 * 8)	/* another data segment */
 
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
 
 /*
  * Matching rules for certain types of segments.
@@ -192,17 +191,6 @@
 #define get_kernel_rpl()  0
 #endif
 
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
-
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
 #define IDT_ENTRIES 256
 #define NUM_EXCEPTION_VECTORS 32
 /* Bitmask of exception vectors which push an error code on the stack */
-- 
2.0.0


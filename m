Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbaLKM1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:27:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaLKM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:27:30 -0500
Date: Thu, 11 Dec 2014 04:27:16 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-be9d1738b17f066b9d2f9e63eb6e2abda997fa1b@git.kernel.org>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, luto@amacapital.net,
        tglx@linutronix.de, bp@suse.de
Reply-To: tglx@linutronix.de, bp@suse.de, luto@amacapital.net, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org
In-Reply-To: <1418127959-29902-1-git-send-email-bp@alien8.de>
References: <1418127959-29902-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/asm: Unify segment selector defines
Git-Commit-ID: be9d1738b17f066b9d2f9e63eb6e2abda997fa1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be9d1738b17f066b9d2f9e63eb6e2abda997fa1b
Gitweb:     http://git.kernel.org/tip/be9d1738b17f066b9d2f9e63eb6e2abda997fa1b
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 9 Dec 2014 13:25:59 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:45:03 +0100

x86/asm: Unify segment selector defines

Those are identical on 32- and 64-bit, unify them. No functional
change.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418127959-29902-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/segment.h | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 6f1c3a8..db257a5 100644
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

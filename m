Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3FGXIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:08:16 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61585 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3FGXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:52 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 18/31] mips/kvm: Add pt_regs slots for BadInstr and BadInstrP
Date: Fri,  7 Jun 2013 16:03:22 -0700
Message-Id: <1370646215-6543-19-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

These save the instruction word to be used by MIPSVZ code for
instruction emulation.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/ptrace.h | 4 ++++
 arch/mips/kernel/asm-offsets.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 5e6cd09..d080716 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -46,6 +46,10 @@ struct pt_regs {
 	unsigned long long mpl[3];	  /* MTM{0,1,2} */
 	unsigned long long mtp[3];	  /* MTP{0,1,2} */
 #endif
+#ifdef CONFIG_KVM_MIPSVZ
+	unsigned int cp0_badinstr;	/* Only populated on do_page_fault_{0,1} */
+	unsigned int cp0_badinstrp;	/* Only populated on do_page_fault_{0,1} */
+#endif
 } __aligned(8);
 
 struct task_struct;
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 03bf363..c5cc28f 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -71,6 +71,10 @@ void output_ptreg_defines(void)
 	OFFSET(PT_MPL, pt_regs, mpl);
 	OFFSET(PT_MTP, pt_regs, mtp);
 #endif /* CONFIG_CPU_CAVIUM_OCTEON */
+#ifdef CONFIG_KVM_MIPSVZ
+	OFFSET(PT_BADINSTR, pt_regs, cp0_badinstr);
+	OFFSET(PT_BADINSTRP, pt_regs, cp0_badinstrp);
+#endif
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 	BLANK();
 }
-- 
1.7.11.7


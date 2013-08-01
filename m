Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3HAXqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:46:00 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:58035 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab3HAXp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:45:58 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] uprobes: move function declarations out of arch
Date: Thu,  1 Aug 2013 19:45:45 -0400
Message-Id: <1375400753-3454-2-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Move the function declarations from the arch header to the common
header, since only the function bodies are architecture-specific.
These changes are from Vincent Rabin's uprobes patch.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/x86/include/asm/uprobes.h | 7 -------
 include/linux/uprobes.h        | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 6e51979..b20b4d6 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -49,11 +49,4 @@ struct arch_uprobe_task {
 	unsigned int			saved_tf;
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
-extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
-extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 06f28be..4e3b847 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -30,6 +30,7 @@
 struct vm_area_struct;
 struct mm_struct;
 struct inode;
+struct notifier_block;
 
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 # include <asm/uprobes.h>
@@ -125,6 +126,13 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
+extern void uprobe_reset_state(struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
+extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
+extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
+extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
-- 
1.8.1.2


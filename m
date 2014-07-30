Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaG3X6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:58:10 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63983 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaG3X5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:57:52 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        k.khlebnikov@samsung.com, olof@lixom.net, peterz@infradead.org,
        takahiro.akashi@linaro.org, tglx@linutronix.de, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dwmw2@infradead.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 4/4] arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
Date: Wed, 30 Jul 2014 16:57:29 -0700
Message-Id: <1406764649-20326-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to get the value of the stack pointer.
This change supports being able to compile the kernel with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/kernel/traps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index c43cfa9..0aeb316 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -132,7 +132,6 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
 static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 {
 	struct stackframe frame;
-	const register unsigned long current_sp asm ("sp");
 
 	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
 
@@ -145,7 +144,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 		frame.pc = regs->pc;
 	} else if (tsk == current) {
 		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.sp = current_sp;
+		frame.sp = current_stack_pointer;
 		frame.pc = (unsigned long)dump_backtrace;
 	} else {
 		/*
-- 
1.9.1


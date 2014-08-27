Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaH0E3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:29:55 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37502 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaH0E3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:51 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        cl@linux-foundation.org, jays.lee@samsung.com,
        k.khlebnikov@samsung.com, larry.bassel@linaro.org, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        tj@kernel.org, will.deacon@arm.com
Cc: christoffer.dall@linaro.org, kgene.kim@samsung.com, khilman@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sungjinn.chung@samsung.com, Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH V2 4/6] arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
Date: Tue, 26 Aug 2014 21:29:32 -0700
Message-Id: <1409113774-3172-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
References: <20140826141608.GT23445@arm.com>
 <1409113774-3172-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to get the value of the stack pointer.
This change supports being able to compile the kernel with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Olof Johansson <olof@lixom.net>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/traps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 02cd3f0..de1b085 100644
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


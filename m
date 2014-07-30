Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaG3X6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:58:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58123 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaG3X5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:57:48 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        k.khlebnikov@samsung.com, olof@lixom.net, peterz@infradead.org,
        takahiro.akashi@linaro.org, tglx@linutronix.de, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dwmw2@infradead.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH 2/4] arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
Date: Wed, 30 Jul 2014 16:57:27 -0700
Message-Id: <1406764649-20326-3-git-send-email-behanw@converseincode.com>
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
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon M??ller <dl9pf@gmx.de>
---
 arch/arm64/kernel/stacktrace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 55437ba..407991b 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -111,10 +111,9 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 		frame.sp = thread_saved_sp(tsk);
 		frame.pc = thread_saved_pc(tsk);
 	} else {
-		register unsigned long current_sp asm("sp");
 		data.no_sched_functions = 0;
 		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.sp = current_sp;
+		frame.sp = current_stack_pointer;
 		frame.pc = (unsigned long)save_stack_trace_tsk;
 	}
 
-- 
1.9.1


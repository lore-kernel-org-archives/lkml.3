Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaH0EbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:31:03 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34277 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaH0E3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:46 -0400
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
Subject: [PATCH V2 2/6] arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
Date: Tue, 26 Aug 2014 21:29:30 -0700
Message-Id: <1409113774-3172-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
References: <20140826141608.GT23445@arm.com>
 <1409113774-3172-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to get the value of the stack pointer.
This change supports being able to compile the kernel with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
Reviewed-by: Olof Johansson <olof@lixom.net>
Acked-by: Will Deacon <will.deacon@arm.com>
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


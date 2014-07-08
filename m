Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaGHUSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:18:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56175 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaGHUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:16:50 -0400
From: behanw@converseincode.com
To: anurag19aggarwal@gmail.com, catalin.marinas@arm.com, charlebm@gmail.com,
        dave.long@linaro.org, k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, will.deacon@arm.com
Cc: behanw@converseincode.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rabin@rab.in, rostedt@goodmis.org,
        dwmw2@infradead.org
Subject: [PATCH 4/6] arm: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
Date: Tue,  8 Jul 2014 13:16:14 -0700
Message-Id: <1404850576-2006-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404850576-2006-1-git-send-email-behanw@converseincode.com>
References: <1404850576-2006-1-git-send-email-behanw@converseincode.com>
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
 arch/arm/kernel/stacktrace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index f065eb0..92b7237 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -134,12 +134,10 @@ static noinline void __save_stack_trace(struct task_struct *tsk,
 		frame.pc = thread_saved_pc(tsk);
 #endif
 	} else {
-		register unsigned long current_sp asm ("sp");
-
 		/* We don't want this function nor the caller */
 		data.skip += 2;
 		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.sp = current_sp;
+		frame.sp = current_stack_pointer;
 		frame.lr = (unsigned long)__builtin_return_address(0);
 		frame.pc = (unsigned long)__save_stack_trace;
 	}
-- 
1.9.1


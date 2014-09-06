Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIFAKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:10:36 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59019 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIFAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:06:54 -0400
From: behanw@converseincode.com
To: a.ryabinin@samsung.com, anurag19aggarwal@gmail.com, charlebm@gmail.com,
        cl@linux-foundation.org, dave.long@linaro.org,
        k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        tj@kernel.org, u.kleine-koenig@pengutronix.de
Cc: behanw@converseincode.com, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, rric@kernel.org,
        will.deacon@arm.com
Subject: [PATCH v2 4/7] arm: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
Date: Fri,  5 Sep 2014 17:06:14 -0700
Message-Id: <1409961977-11762-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
References: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
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


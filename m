Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3IFVbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:31:11 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51868 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3IFVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:31:09 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/5] arm: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
Date: Fri,  6 Sep 2013 17:28:10 -0400
Message-Id: <1378502899-1241-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The existing code uses named registers to get the value of the stack pointer.
The new current_stack_pointer macro is more readable and allows for a central
portable implementation of how to get the stack pointer with ASM.  This change
supports being able to compile the kernel with both gcc and Clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/kernel/stacktrace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..8c23310 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -109,11 +109,9 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 		frame.pc = thread_saved_pc(tsk);
 #endif
 	} else {
-		register unsigned long current_sp asm ("sp");
-
 		data.no_sched_functions = 0;
 		frame.fp = (unsigned long)__builtin_frame_address(0);
-		frame.sp = current_sp;
+		frame.sp = current_stack_pointer;
 		frame.lr = (unsigned long)__builtin_return_address(0);
 		frame.pc = (unsigned long)save_stack_trace_tsk;
 	}
-- 
1.8.1.2


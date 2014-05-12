Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaELCMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:12:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34475 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaELBmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:09 -0400
Message-Id: <20140512003200.763002327@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Subject: [ 003/143] Revert "x86, ptrace: fix build breakage with gcc 4.7"
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

This reverts commit 4ed3bb08f1698c62685278051c19f474fbf961d2.

As reported by Sven-Haegar Koch, this patch breaks make headers_check :

   CHECK   include (0 files)
   CHECK   include/asm (54 files)
   /home/haegar/src/2.6.32/linux/usr/include/asm/ptrace.h:5: included file 'linux/linkage.h' is not exported

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/ptrace.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e668d72..0f0d908 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_PTRACE_H
 
 #include <linux/compiler.h>	/* For __user */
-#include <linux/linkage.h>	/* For asmregparm */
 #include <asm/ptrace-abi.h>
 #include <asm/processor-flags.h>
 
@@ -143,8 +142,8 @@ extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
-extern asmregparm long syscall_trace_enter(struct pt_regs *);
-extern asmregparm void syscall_trace_leave(struct pt_regs *);
+extern long syscall_trace_enter(struct pt_regs *);
+extern void syscall_trace_leave(struct pt_regs *);
 
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
-- 
1.7.12.2.21.g234cd45.dirty




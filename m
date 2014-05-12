Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaELBoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34771 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbaELBoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:02 -0400
Message-Id: <20140512003200.804363332@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sven-Haegar Koch <haegar@sdinet.de>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 004/143] x86, ptrace: fix build breakage with gcc 4.7 (second try)
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

syscall_trace_enter() and syscall_trace_leave() are only called from
within asm code and do not need to be declared in the .c at all.
Removing their reference fixes the build issue that was happening
with gcc 4.7.

Both Sven-Haegar Koch and Christoph Biedl confirmed this patch
addresses their respective build issues.

Cc: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/ptrace.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0f0d908..1ec926d 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -142,9 +142,6 @@ extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
-extern long syscall_trace_enter(struct pt_regs *);
-extern void syscall_trace_leave(struct pt_regs *);
-
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
 	return regs->ax;
-- 
1.7.12.2.21.g234cd45.dirty




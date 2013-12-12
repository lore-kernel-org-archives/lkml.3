Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3LLOQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:16:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3LLOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:15:58 -0500
Date: Thu, 12 Dec 2013 06:15:31 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-d8af4ce490e92adfa123ae79899332bd829903e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/traps:
  Clean up error exception handler definitions
Git-Commit-ID: d8af4ce490e92adfa123ae79899332bd829903e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 06:15:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8af4ce490e92adfa123ae79899332bd829903e7
Gitweb:     http://git.kernel.org/tip/d8af4ce490e92adfa123ae79899332bd829903e7
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 12 Dec 2013 14:46:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Dec 2013 14:46:42 +0100

x86/traps: Clean up error exception handler definitions

So I was reading the exception handler generation code and got a real
headache looking at the unstructured mess that our DO_ERROR*()
generation code is today.

Make it more readable.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-kuabysiykvUJpgus35lhnhvs@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b857ed8..57409f6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -211,21 +211,17 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	exception_exit(prev_state);					\
 }
 
-DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
-		regs->ip)
-DO_ERROR(X86_TRAP_OF, SIGSEGV, "overflow", overflow)
-DO_ERROR(X86_TRAP_BR, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(X86_TRAP_UD, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN,
-		regs->ip)
-DO_ERROR(X86_TRAP_OLD_MF, SIGFPE, "coprocessor segment overrun",
-		coprocessor_segment_overrun)
-DO_ERROR(X86_TRAP_TS, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(X86_TRAP_NP, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
+DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow					  )
+DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds						  )
+DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op,		     ILL_ILLOPN, regs->ip )
+DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun			  )
+DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS					  )
+DO_ERROR     (X86_TRAP_NP,     SIGBUS,  "segment not present",		segment_not_present				  )
 #ifdef CONFIG_X86_32
-DO_ERROR(X86_TRAP_SS, SIGBUS, "stack segment", stack_segment)
+DO_ERROR     (X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment					  )
 #endif
-DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
-		BUS_ADRALN, 0)
+DO_ERROR_INFO(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check,	     BUS_ADRALN, 0	  )
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */

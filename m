Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaEHTMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbaEHTMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:32 -0400
Date: Thu, 8 May 2014 21:12:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] x86/traps: Kill DO_ERROR_INFO()
Message-ID: <20140508191209.GA16933@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that DO_ERROR_INFO() doesn't differ from DO_ERROR() we can remove
it and use DO_ERROR() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/traps.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c9dd741..73b3ea3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -224,23 +224,17 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_error_trap(regs, error_code, str, trapnr, signr);		\
 }
 
-#define DO_ERROR_INFO(trapnr, signr, str, name)				\
-dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	do_error_trap(regs, error_code, str, trapnr, signr);		\
-}
-
-DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error)
-DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow)
-DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds)
-DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op)
-DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun)
-DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS)
-DO_ERROR     (X86_TRAP_NP,     SIGBUS,  "segment not present",		segment_not_present)
+DO_ERROR(X86_TRAP_DE,     SIGFPE,  "divide error",		divide_error)
+DO_ERROR(X86_TRAP_OF,     SIGSEGV, "overflow",			overflow)
+DO_ERROR(X86_TRAP_BR,     SIGSEGV, "bounds",			bounds)
+DO_ERROR(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op)
+DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",coprocessor_segment_overrun)
+DO_ERROR(X86_TRAP_TS,     SIGSEGV, "invalid TSS",		invalid_TSS)
+DO_ERROR(X86_TRAP_NP,     SIGBUS,  "segment not present",	segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR     (X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
+DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 #endif
-DO_ERROR_INFO(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
+DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
-- 
1.5.5.1


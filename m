Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaIOUBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:01:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaIOTrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.10 24/71] MIPS: Cleanup flags in syscall flags handlers.
Date: Mon, 15 Sep 2014 12:26:22 -0700
Message-Id: <20140915192639.516538533@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit e7f3b48af7be9f8007a224663a5b91340626fed5 upstream.

This will simplify further modifications.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/thread_info.h |    2 ++
 arch/mips/kernel/scall32-o32.S      |    2 +-
 arch/mips/kernel/scall64-64.S       |    2 +-
 arch/mips/kernel/scall64-n32.S      |    2 +-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -131,6 +131,8 @@ static inline struct thread_info *curren
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
+#define _TIF_WORK_SYSCALL_ENTRY	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
+
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
 
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -52,7 +52,7 @@ NESTED(handle_sys, PT_SIZE, sp)
 
 stack_done:
 	lw	t0, TI_FLAGS($28)	# syscall tracing enabled?
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	and	t0, t1
 	bnez	t0, syscall_trace_entry # -> yes
 
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -54,7 +54,7 @@ NESTED(handle_sys64, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, syscall_trace_entry
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -47,7 +47,7 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, n32_syscall_trace_entry
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -81,7 +81,7 @@ NESTED(handle_sys, PT_SIZE, sp)
 	PTR	4b, bad_stack
 	.previous
 
-	li	t1, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
 	bnez	t0, trace_a_syscall



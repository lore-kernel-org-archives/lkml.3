Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaGHToY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:44:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54080 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ralf Baechle" <ralf@linux-mips.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.620657333@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 108/125] MIPS: Cleanup flags in syscall flags handlers.
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit e7f3b48af7be9f8007a224663a5b91340626fed5 upstream.

This will simplify further modifications.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/include/asm/thread_info.h | 2 ++
 arch/mips/kernel/scall32-o32.S      | 2 +-
 arch/mips/kernel/scall64-64.S       | 2 +-
 arch/mips/kernel/scall64-n32.S      | 2 +-
 arch/mips/kernel/scall64-o32.S      | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -149,6 +149,8 @@ register struct thread_info *__current_t
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
 	bnez	t0, syscall_trace_entry	# -> yes
 
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
@@ -53,7 +53,7 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 
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


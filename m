Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaEVM1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:27:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbaEVM1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:27:15 -0400
Date: Thu, 22 May 2014 05:26:14 -0700
From: tip-bot for James Hogan <tipbot@zytor.com>
Message-ID: <tip-31e6cdefd377ae90bea5c6a4e1dc519793577a24@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        james.hogan@imgtec.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        james.hogan@imgtec.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <536CEB7E.9080007@imgtec.com>
References: <536CEB7E.9080007@imgtec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] metag: Remove TIF_POLLING_NRFLAG
Git-Commit-ID: 31e6cdefd377ae90bea5c6a4e1dc519793577a24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31e6cdefd377ae90bea5c6a4e1dc519793577a24
Gitweb:     http://git.kernel.org/tip/31e6cdefd377ae90bea5c6a4e1dc519793577a24
Author:     James Hogan <james.hogan@imgtec.com>
AuthorDate: Fri, 9 May 2014 15:36:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 10:22:10 +0200

metag: Remove TIF_POLLING_NRFLAG

The Meta idle function jumps into the interrupt handler which
efficiently blocks waiting for the next interrupt when it reads the
interrupt status register (TXSTATI). No other (polling) idle functions
can be used, therefore TIF_POLLING_NRFLAG is unnecessary, so lets remove
it.

Peter Zijlstra said:
> Most archs have (x86) hlt or (arm) wfi like idle instructions, and if
> that is your only possible idle function, you'll require the interrupt
> to wake up and there's really no point to having the POLLING bit.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/536CEB7E.9080007@imgtec.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/include/asm/thread_info.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index b19e9c5..4771133 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -117,10 +117,8 @@ static inline int kstack_end(void *addr)
 #define TIF_SECCOMP		5	/* secure computing */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
-#define TIF_POLLING_NRFLAG      8	/* true if poll_idle() is polling
-					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE		9	/* is terminating due to OOM killer */
-#define TIF_SYSCALL_TRACEPOINT  10	/* syscall tracepoint instrumentation */
+#define TIF_MEMDIE		8	/* is terminating due to OOM killer */
+#define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
 
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)

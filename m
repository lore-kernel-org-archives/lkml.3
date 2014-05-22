Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaEVM1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:27:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaEVM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:27:20 -0400
Date: Thu, 22 May 2014 05:26:26 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-842514849a616e9b61acad65771c7afe01e651f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140509170649.GG13658@twins.programming.kicks-ass.net>
References: <20140509170649.GG13658@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] arm64: Remove TIF_POLLING_NRFLAG
Git-Commit-ID: 842514849a616e9b61acad65771c7afe01e651f9
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

Commit-ID:  842514849a616e9b61acad65771c7afe01e651f9
Gitweb:     http://git.kernel.org/tip/842514849a616e9b61acad65771c7afe01e651f9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 9 May 2014 19:04:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 10:22:58 +0200

arm64: Remove TIF_POLLING_NRFLAG

The only idle method for arm64 is WFI and it therefore
unconditionally requires the reschedule interrupt when idle.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: http://lkml.kernel.org/r/20140509170649.GG13658@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm64/include/asm/thread_info.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b..7b8e3a2 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -95,13 +95,11 @@ static inline struct thread_info *current_thread_info(void)
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_NOTIFY_RESUME	- callback before returning to user
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
- *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
-#define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaGUOMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:12:36 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbaGUOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:14 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, rostedt@goodmis.org,
        mingo@redhat.com, roland@redhat.com, oleg@redhat.com
Subject: [PATCH 24/43] tracehook_signal_handler: Remove sig, info, ka and regs
Date: Mon, 21 Jul 2014 16:03:10 +0200
Message-Id: <1405951409-16953-25-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

These parameters are nowhere used, so we can remove them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/tracehook.h | 8 +-------
 kernel/signal.c           | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6f8ab7d..84d4972 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -133,10 +133,6 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 
 /**
  * tracehook_signal_handler - signal handler setup is complete
- * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
- * @ka:			sigaction setting that chose the handler
- * @regs:		user register state
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * Called by the arch code after a signal handler has been set up.
@@ -146,9 +142,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
  * Called without locks, shortly before returning to user mode
  * (or handling more signals).
  */
-static inline void tracehook_signal_handler(int sig, siginfo_t *info,
-					    const struct k_sigaction *ka,
-					    struct pt_regs *regs, int stepping)
+static inline void tracehook_signal_handler(int stepping)
 {
 	if (stepping)
 		ptrace_notify(SIGTRAP);
diff --git a/kernel/signal.c b/kernel/signal.c
index a4077e9..c4d4766 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2379,7 +2379,7 @@ void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
 	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&blocked, sig);
 	set_current_blocked(&blocked);
-	tracehook_signal_handler(sig, info, ka, regs, stepping);
+	tracehook_signal_handler(stepping);
 }
 
 void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
-- 
1.8.4.5


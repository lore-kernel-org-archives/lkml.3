Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaCBX7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:39 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62411 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaCBX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:37 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, vgupta@synopsys.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, vapier@gentoo.org, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, rkuo@codeaurora.org, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, hch@infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 26/44] tracehook_signal_handler: Remove sig, info, ka and regs
Date: Mon,  3 Mar 2014 00:59:09 +0100
Message-Id: <1393804758-7916-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These parameters are nowhere used, so we can remove them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/tracehook.h | 8 +-------
 kernel/signal.c           | 2 +-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 1e98b55..c4877e3 100644
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
index bd649bd..b0a6256 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2403,7 +2403,7 @@ void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
 	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&blocked, sig);
 	set_current_blocked(&blocked);
-	tracehook_signal_handler(sig, info, ka, regs, stepping);
+	tracehook_signal_handler(stepping);
 }
 
 void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
-- 
1.8.4.2


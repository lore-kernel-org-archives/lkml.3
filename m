Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3JHLgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:36:39 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1665 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756645Ab3JHLgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:36:35 -0400
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
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 27/29] get_signal_to_deliver: remove regs and cookie args
Date: Tue,  8 Oct 2013 13:36:17 +0200
Message-Id: <1381232179-4385-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381232179-4385-1-git-send-email-richard@nod.at>
References: <1381232179-4385-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both arguments are unused, remove them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h | 5 ++---
 kernel/signal.c        | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..735e0a3 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -285,7 +285,7 @@ struct ksignal {
 	int sig;
 };
 
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
@@ -297,8 +297,7 @@ extern void exit_signals(struct task_struct *tsk);
 #define get_signal(ksig)					\
 ({								\
 	struct ksignal *p = (ksig);				\
-	p->sig = get_signal_to_deliver(&p->info, &p->ka,	\
-					signal_pt_regs(), NULL);\
+	p->sig = get_signal_to_deliver(&p->info, &p->ka); \
 	p->sig > 0;						\
 })
 
diff --git a/kernel/signal.c b/kernel/signal.c
index ded28b9..5cf68fb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2189,8 +2189,7 @@ static int ptrace_signal(int signr, siginfo_t *info)
 	return signr;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka)
 {
 	struct sighand_struct *sighand = current->sighand;
 	struct signal_struct *signal = current->signal;
-- 
1.8.1.4


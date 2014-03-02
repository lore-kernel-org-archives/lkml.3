Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaCBX7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:50 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62416 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaCBX7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:48 -0500
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
Subject: [PATCH 31/44] arm64: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:14 +0100
Message-Id: <1393804758-7916-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm64/kernel/signal.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index f6f23dd..165a72a 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -19,7 +19,6 @@
 
 #include <linux/errno.h>
 #include <linux/signal.h>
-#include <linux/personality.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
@@ -282,16 +281,10 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
-	int usig = ksig->sig;
+	int usig = translate_signal(ksig->sig);
 	int ret;
 
 	/*
-	 * translate the signal
-	 */
-	if (usig < 32 && thread->exec_domain && thread->exec_domain->signal_invmap)
-		usig = thread->exec_domain->signal_invmap[usig];
-
-	/*
 	 * Set up the stack frame
 	 */
 	if (is_compat_task()) {
-- 
1.8.4.2


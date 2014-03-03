Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaCCABh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:37 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaCCABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:34 -0500
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
Subject: [PATCH 42/44] x86: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:42 +0100
Message-Id: <1393804844-8008-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/kernel/signal.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de68..cad7c49 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -18,7 +18,6 @@
 #include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
@@ -596,12 +595,10 @@ badframe:
 static int signr_convert(int sig)
 {
 #ifdef CONFIG_X86_32
-	struct thread_info *info = current_thread_info();
-
-	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
-		return info->exec_domain->signal_invmap[sig];
-#endif /* CONFIG_X86_32 */
+	return translate_signal(sig);
+#else /* CONFIG_X86_32 */
 	return sig;
+#endif
 }
 
 static int
-- 
1.8.4.2


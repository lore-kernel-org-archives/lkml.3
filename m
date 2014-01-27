Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaA0JwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:52:01 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58463 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbaA0Jv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:51:59 -0500
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 04:51:59 EST
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 1/2] x86: dumpstack, use pr_cont
Date: Mon, 27 Jan 2014 10:28:03 +0100
Message-Id: <1390814884-15519-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dumping flags with which the kernel was built, we print them one
by one in separate printks. Let's use pr_cont as they are
continuation prints.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/dumpstack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index d9c12d3022a7..8bd36be26609 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -257,15 +257,15 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk(KERN_DEFAULT
 	       "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
+	pr_cont("PREEMPT ");
 #endif
 #ifdef CONFIG_SMP
-	printk("SMP ");
+	pr_cont("SMP ");
 #endif
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
+	pr_cont("DEBUG_PAGEALLOC");
 #endif
-	printk("\n");
+	pr_cont("\n");
 	if (notify_die(DIE_OOPS, str, regs, err,
 			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
-- 
1.8.5.2


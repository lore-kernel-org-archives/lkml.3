Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3DXLUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:20:33 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48976 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757682Ab3DXLTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:19:33 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>, Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH -v6 4/5] checkpatch.pl the new kernel/reboot.c file.
Date: Wed, 24 Apr 2013 06:18:52 -0500
Message-Id: <1366802333-8890-5-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366802333-8890-1-git-send-email-holt@sgi.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did allow the remaining 81 character line behind.  It did not seem
like it was worth changing.  Otherwise, it now passes checkpatch.pl.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>

---

Changes since -v3:
Integrated feedback from Joe Perches.
---
 kernel/reboot.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index ff92601..7f4658f 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 2013  Linus Torvalds
  */
 
+#define pr_fmt(fmt)	"reboot: " fmt
+
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -99,9 +101,9 @@ void kernel_restart(char *cmd)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
-		printk(KERN_EMERG "Restarting system.\n");
+		pr_emerg("Restarting system\n");
 	else
-		printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
+		pr_emerg("Restarting system with command '%s'\n", cmd);
 	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
@@ -110,7 +112,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -125,11 +127,10 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "System halted.\n");
+	pr_emerg("System halted\n");
 	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
-
 EXPORT_SYMBOL_GPL(kernel_halt);
 
 /**
@@ -144,7 +145,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "Power down.\n");
+	pr_emerg("Power down\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
@@ -173,10 +174,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
-	    (magic2 != LINUX_REBOOT_MAGIC2 &&
-	                magic2 != LINUX_REBOOT_MAGIC2A &&
+			(magic2 != LINUX_REBOOT_MAGIC2 &&
+			magic2 != LINUX_REBOOT_MAGIC2A &&
 			magic2 != LINUX_REBOOT_MAGIC2B &&
-	                magic2 != LINUX_REBOOT_MAGIC2C))
+			magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
 	/*
@@ -285,14 +286,11 @@ static int __orderly_poweroff(bool force)
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
 	} else {
-		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
-					 __func__, poweroff_cmd);
 		ret = -ENOMEM;
 	}
 
 	if (ret && force) {
-		printk(KERN_WARNING "Failed to start orderly shutdown: "
-					"forcing the issue\n");
+		pr_warn("Failed to start orderly shutdown: forcing the issue\n");
 		/*
 		 * I guess this should try to kick off some daemon to sync and
 		 * poweroff asap.  Or not even bother syncing if we're doing an
-- 
1.8.1.2


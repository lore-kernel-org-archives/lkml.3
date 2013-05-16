Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3EPQPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:15:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753721Ab3EPQPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:07 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v11 resend 05/11] checkpatch.pl the new kernel/reboot.c file.
Date: Thu, 16 May 2013 11:14:44 -0500
Message-Id: <1368720890-57711-6-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368720890-57711-1-git-send-email-holt@sgi.com>
References: <1368720890-57711-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the new file to pass scripts/checkpatch.pl

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>

---

Changes since v6:
 - Removed last remaining line length warning.
---
 include/linux/reboot.h |  2 +-
 kernel/reboot.c        | 28 +++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 23b3630..c6eba21 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -26,7 +26,7 @@ extern void machine_shutdown(void);
 struct pt_regs;
 extern void machine_crash_shutdown(struct pt_regs *);
 
-/* 
+/*
  * Architecture independent implemenations of sys_reboot commands.
  */
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 0616483..abb6a04 100644
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
@@ -114,9 +116,9 @@ void kernel_restart(char *cmd)
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
@@ -125,7 +127,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -140,11 +142,10 @@ void kernel_halt(void)
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
@@ -159,7 +160,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "Power down.\n");
+	pr_emerg("Power down\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
@@ -188,10 +189,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
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
@@ -234,7 +235,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
-		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
+		ret = strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1);
+		if (ret < 0) {
 			ret = -EFAULT;
 			break;
 		}
@@ -282,7 +284,6 @@ void ctrl_alt_del(void)
 	else
 		kill_cad_pid(SIGINT, 1);
 }
-	
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
@@ -301,14 +302,11 @@ static int __orderly_poweroff(bool force)
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
1.8.2.1


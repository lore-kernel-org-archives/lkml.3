Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3CWQsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 12:48:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3CWQsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:48:54 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, rusty@rustcorp.com.au,
        viro@zeniv.linux.org.uk, jim.cromie@gmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] init: raise log level
Date: Sat, 23 Mar 2013 17:48:39 +0100
Message-Id: <1364057319-9455-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel was booted with the "quiet" boot option we have currently no
chance to see why an initrd failes.
Change KERN_WARNING to KERN_ERR to see what is going on.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 init/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 63534a1..1d63387 100644
--- a/init/main.c
+++ b/init/main.c
@@ -832,7 +832,7 @@ static int __ref kernel_init(void *unused)
 	if (ramdisk_execute_command) {
 		if (!run_init_process(ramdisk_execute_command))
 			return 0;
-		printk(KERN_WARNING "Failed to execute %s\n",
+		printk(KERN_ERR "Failed to execute %s\n",
 				ramdisk_execute_command);
 	}
 
@@ -845,7 +845,7 @@ static int __ref kernel_init(void *unused)
 	if (execute_command) {
 		if (!run_init_process(execute_command))
 			return 0;
-		printk(KERN_WARNING "Failed to execute %s.  Attempting "
+		printk(KERN_ERR "Failed to execute %s.  Attempting "
 					"defaults...\n", execute_command);
 	}
 	if (!run_init_process("/sbin/init") ||
@@ -891,7 +891,7 @@ static noinline void __init kernel_init_freeable(void)
 
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
+		printk(KERN_ERR "Warning: unable to open an initial console.\n");
 
 	(void) sys_dup(0);
 	(void) sys_dup(0);
-- 
1.8.1.4


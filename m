Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaFWDK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:10:58 -0400
Received: from ozlabs.org ([103.22.144.67]:42417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaFWDK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:10:57 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: trivial@kernel.org
Cc: <linux-kernel@vger.kernel.org>, masami.hiramatsu.pt@hitachi.com
Subject: [PATCH] samples/kprobes: Update jprobe_example.c for do_fork() change
Date: Mon, 23 Jun 2014 13:10:27 +1000
Message-Id: <1403493027-16638-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit e80d666 "flagday: kill pt_regs argument of do_fork()", the
arguments to do_fork() changed.

The example code in jprobe_example.c was not updated to match, so the
arguments inside the jprobe handler do not match reality.

Fix it by updating the arguments to match do_fork(). While we're at it
use pr_info() for brevity, and print stack_start as well for interest.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 samples/kprobes/jprobe_example.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/samples/kprobes/jprobe_example.c b/samples/kprobes/jprobe_example.c
index b754135..9119ac6 100644
--- a/samples/kprobes/jprobe_example.c
+++ b/samples/kprobes/jprobe_example.c
@@ -24,12 +24,11 @@
 
 /* Proxy routine having the same arguments as actual do_fork() routine */
 static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
-	      struct pt_regs *regs, unsigned long stack_size,
-	      int __user *parent_tidptr, int __user *child_tidptr)
+	      unsigned long stack_size, int __user *parent_tidptr,
+	      int __user *child_tidptr)
 {
-	printk(KERN_INFO "jprobe: clone_flags = 0x%lx, stack_size = 0x%lx,"
-			" regs = 0x%p\n",
-	       clone_flags, stack_size, regs);
+	pr_info("jprobe: clone_flags = 0x%lx, stack_start = 0x%lx "
+		"stack_size = 0x%lx\n", clone_flags, stack_start, stack_size);
 
 	/* Always end with a call to jprobe_return(). */
 	jprobe_return();
-- 
1.9.1


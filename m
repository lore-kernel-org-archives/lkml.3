Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaBEUxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:53:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:54888 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaBEUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Shawn Guo <shawn.guo@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 091/213] kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
Date: Wed, 5 Feb 2014 15:00:46 -0500
Message-ID: <1391630568-49251-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f96972f2dc6365421cf2366ebd61ee4cf060c8d5 upstream.

As kernel_power_off() calls disable_nonboot_cpus(), we may also want to
have kernel_restart() call disable_nonboot_cpus().  Doing so can help
machines that require boot cpu be the last alive cpu during reboot to
survive with kernel restart.

This fixes one reboot issue seen on imx6q (Cortex-A9 Quad).  The machine
requires that the restart routine be run on the primary cpu rather than
secondary ones.  Otherwise, the secondary core running the restart
routine will fail to come to online after reboot.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index 0324c1cd8e7b..006883113861 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -308,6 +308,7 @@ void kernel_restart_prepare(char *cmd)
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
-- 
1.8.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FDWlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35129 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3FDWkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:39 -0400
Message-Id: <20130604172131.386034328@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 026/184] kernel/sys.c: call disable_nonboot_cpus() in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 kernel_restart()

From: Shawn Guo <shawn.guo@linaro.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index e9512b1..5a381e6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -303,6 +303,7 @@ void kernel_restart_prepare(char *cmd)
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
-- 
1.7.12.2.21.g234cd45.dirty




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbbAWSDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:03:52 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:43894 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbbAWSDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:03:49 -0500
From: Daniel Church <dchurch@andplus.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Daniel Church <dchurch@andplus.com>
Subject: [PATCH 2/2] posix-timers: Exposes DELAYTIMER_MAX constant used to govern overruns
Date: Fri, 23 Jan 2015 13:03:31 -0500
Message-Id: <1422036211-10934-3-git-send-email-dchurch@andplus.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422036211-10934-1-git-send-email-dchurch@andplus.com>
References: <1422036211-10934-1-git-send-email-dchurch@andplus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX.1-2001 specification of timer_getoverrun() supports constant
DELAYTIMER_MAX which prevents overflow and caps overrun count.  Exposes
delaytimer_max value to userland via /proc/sys/kernel/delaytimer_max such
that GLIBC can support DELAYTIMER_MAX constant.

Signed-off-by: Daniel Church <dchurch@andplus.com>
---
 kernel/sysctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 137c7f6..b283808 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -63,6 +63,7 @@
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
 #include <linux/kexec.h>
+#include <linux/posix-timers.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -761,6 +762,13 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
+		.procname	= "delaytimer_max",
+		.data		= &delaytimer_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
 		.maxlen		= sizeof (int),
-- 
1.9.1


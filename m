Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbbAWVvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:51:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54315 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756576AbbAWVv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:51:28 -0500
Message-Id: <20150123215125.920046210@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 16:50:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] tracing: Remove unneeded includes of debugfs.h and fs.h
References: <20150123215010.626661716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Remove-unneeded-includes-of-debugfs.h-and-fs.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The creation of tracing files and directories is for the most part
encapsulated in helper functions in trace.c. Other files do not need to
include debugfs.h or fs.h, as they may have needed to in the past.

Remove them from the files that do not need them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c        | 2 --
 kernel/trace/trace_branch.c       | 1 -
 kernel/trace/trace_export.c       | 2 --
 kernel/trace/trace_irqsoff.c      | 2 --
 kernel/trace/trace_nop.c          | 2 --
 kernel/trace/trace_printk.c       | 2 --
 kernel/trace/trace_sched_switch.c | 2 --
 kernel/trace/trace_sched_wakeup.c | 2 --
 kernel/trace/trace_stack.c        | 2 --
 9 files changed, 17 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7a4104cb95cb..96079180de3d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -9,7 +9,6 @@
 #include <linux/trace_seq.h>
 #include <linux/spinlock.h>
 #include <linux/irq_work.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>	/* for self test */
@@ -23,7 +22,6 @@
 #include <linux/hash.h>
 #include <linux/list.h>
 #include <linux/cpu.h>
-#include <linux/fs.h>
 
 #include <asm/local.h>
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7d6e2afde669..57cbf1efdd44 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -7,7 +7,6 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/irqflags.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d4ddde28a81a..12e2b99be862 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -6,12 +6,10 @@
 #include <linux/stringify.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/fs.h>
 
 #include "trace_output.h"
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 9bb104f748d0..8523ea345f2b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -10,11 +10,9 @@
  *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/kallsyms.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
-#include <linux/fs.h>
 
 #include "trace.h"
 
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index fcf0a9e48916..8bb2071474dd 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -6,8 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 
 #include "trace.h"
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index c4e70b6bd7fa..7ee4b5cc1ce5 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -5,7 +5,6 @@
  *
  */
 #include <linux/seq_file.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
@@ -15,7 +14,6 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/fs.h>
 
 #include "trace.h"
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 2e293beb186e..419ca37e72c9 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -5,8 +5,6 @@
  *
  */
 #include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 8fb84b362816..d6e1003724e9 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -10,8 +10,6 @@
  *  Copyright (C) 2004 Nadia Yvette Chambers
  */
 #include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 16eddb308c33..e80927b88eb0 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -7,12 +7,10 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
-#include <linux/fs.h>
 
 #include <asm/setup.h>
 
-- 
2.1.4



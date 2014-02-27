Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaB0LLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:11:09 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38105 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaB0LLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:11:07 -0500
Date: Thu, 27 Feb 2014 16:38:46 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Simon Marchi <simon.marchi@polymtl.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Kent Overstreet <koverstreet@google.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michal Simek <michal.simek@xilinx.com>,
        Alan Cox <alan@linux.intel.com>, linux-am33-list@redhat.com,
        josh@joshtriplett.org
Subject: [PATCH 01/46] kernel: Move prototype declaration to header file
 include/linux/thread_info.h
Message-ID: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to header file include/linux/thread_info.h
from arch/mn10300/include/asm/thread_info.h and
arch/tile/include/asm/thread_info.h because it is used by more than one
file.
Also, include the header file in kernel/fork.c,
arch/mn10300/kernel/kgdb.c and arch/tile/kernel/process.c.

This also eliminates the following warning in kernel/fork.c:
kernel/fork.c:136:13: warning: no previous prototype for ‘arch_release_thread_info’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/mn10300/include/asm/thread_info.h |    3 ---
 arch/mn10300/kernel/kgdb.c             |    1 +
 arch/tile/include/asm/thread_info.h    |    2 --
 arch/tile/kernel/process.c             |    1 +
 include/linux/thread_info.h            |    2 ++
 kernel/fork.c                          |    1 +
 6 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index bf280ea..3a4efbe 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -120,9 +120,6 @@ static inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-#ifndef CONFIG_KGDB
-void arch_release_thread_info(struct thread_info *ti);
-#endif
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 
diff --git a/arch/mn10300/kernel/kgdb.c b/arch/mn10300/kernel/kgdb.c
index 9977082..1f4ed5d 100644
--- a/arch/mn10300/kernel/kgdb.c
+++ b/arch/mn10300/kernel/kgdb.c
@@ -13,6 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/kgdb.h>
 #include <linux/uaccess.h>
+#include <linux/thread_info.h>
 #include <unit/leds.h>
 #include <unit/serial.h>
 #include <asm/debugger.h>
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 729aa10..5f204bd 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -83,8 +83,6 @@ struct thread_info {
 
 #ifndef __ASSEMBLY__
 
-void arch_release_thread_info(struct thread_info *info);
-
 /* How to get the thread information struct from C. */
 register unsigned long stack_pointer __asm__("sp");
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 16ed589..5f44885 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/tracehook.h>
 #include <linux/signal.h>
+#include <linux/thread_info.h>
 #include <asm/stack.h>
 #include <asm/switch_to.h>
 #include <asm/homecache.h>
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index fddbe20..b03a087 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -118,6 +118,8 @@ static inline __deprecated void set_need_resched(void)
 	 */
 }
 
+void arch_release_thread_info(struct thread_info *ti);
+
 #define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
 
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..962046c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -71,6 +71,7 @@
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
+#include <linux/thread_info.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab3GQQt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:49:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50231 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab3GQQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:45:06 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 15/18] vtime: Describe overriden functions in dedicated arch headers
Date: Wed, 17 Jul 2013 18:44:28 +0200
Message-Id: <1374079471-3129-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the arch overrides some generic vtime APIs, let it describe
these on a dedicated and standalone header. This way it becomes
convenient to include it in vtime generic headers without irrelevant
stuff in such a low level header.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/ia64/include/asm/Kbuild    |    1 +
 arch/powerpc/include/asm/Kbuild |    1 +
 arch/s390/include/asm/cputime.h |    3 ---
 arch/s390/include/asm/vtime.h   |    7 +++++++
 arch/s390/kernel/vtime.c        |    1 +
 include/linux/vtime.h           |    4 ++++
 6 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/include/asm/vtime.h
 create mode 100644 include/asm-generic/vtime.h

diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 05b03ec..a3456f3 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
 generic-y += trace_clock.h
+generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 650757c..704e6f1 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
+generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index d2ff4137..f65bd36 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -13,9 +13,6 @@
 #include <asm/div64.h>
 
 
-#define __ARCH_HAS_VTIME_ACCOUNT
-#define __ARCH_HAS_VTIME_TASK_SWITCH
-
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
 typedef unsigned long long __nocast cputime_t;
diff --git a/arch/s390/include/asm/vtime.h b/arch/s390/include/asm/vtime.h
new file mode 100644
index 0000000..af9896c
--- /dev/null
+++ b/arch/s390/include/asm/vtime.h
@@ -0,0 +1,7 @@
+#ifndef _S390_VTIME_H
+#define _S390_VTIME_H
+
+#define __ARCH_HAS_VTIME_ACCOUNT
+#define __ARCH_HAS_VTIME_TASK_SWITCH
+
+#endif /* _S390_VTIME_H */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 3fb0935..785c73f 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -19,6 +19,7 @@
 #include <asm/irq_regs.h>
 #include <asm/cputime.h>
 #include <asm/vtimer.h>
+#include <asm/vtime.h>
 #include <asm/irq.h>
 #include "entry.h"
 
diff --git a/include/asm-generic/vtime.h b/include/asm-generic/vtime.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index b1dd2db..2ad0739 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -1,6 +1,10 @@
 #ifndef _LINUX_KERNEL_VTIME_H
 #define _LINUX_KERNEL_VTIME_H
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
+#include <asm/vtime.h>
+#endif
+
 struct task_struct;
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-- 
1.7.5.4


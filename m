Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3HFRXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:23:46 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33582 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3HFRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:23:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 01/11] cpufreq: Cleanup header files included in core
Date: Tue,  6 Aug 2013 22:53:03 +0530
Message-Id: <8aa6f799442fa100bee905952706f65eee66360d.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intends to cleanup following issues in the header files included in
cpufreq core layers:
- Include headers in ascending order, so that we don't add same multiple times
  by mistake.
- <asm/> must be included after <linux/>, so that they override whatever they
  need.
- Remove unnecessary header files
- Don't include files already included by cpufreq.h or cpufreq_governor.h

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c              | 19 ++++++-------------
 drivers/cpufreq/cpufreq_conservative.c | 12 ------------
 drivers/cpufreq/cpufreq_governor.c     |  6 ------
 drivers/cpufreq/cpufreq_governor.h     |  5 ++---
 drivers/cpufreq/cpufreq_ondemand.c     | 12 +-----------
 drivers/cpufreq/cpufreq_performance.c  |  3 +--
 drivers/cpufreq/cpufreq_powersave.c    |  3 +--
 drivers/cpufreq/cpufreq_stats.c        |  9 +--------
 drivers/cpufreq/freq_table.c           |  4 +---
 include/linux/cpufreq.h                | 11 +++--------
 10 files changed, 16 insertions(+), 68 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a7c5aa7..aaccfa0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -17,24 +17,17 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <asm/cputime.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/notifier.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/tick.h>
 #include <linux/device.h>
-#include <linux/slab.h>
-#include <linux/cpu.h>
-#include <linux/completion.h>
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/syscore_ops.h>
-
+#include <linux/tick.h>
 #include <trace/events/power.h>
 
 /**
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index f97cb3d..d2bd9ef 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -11,19 +11,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/cpufreq.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/notifier.h>
-#include <linux/percpu-defs.h>
 #include <linux/slab.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
 #include "cpufreq_governor.h"
 
 /* Conservative governor macros */
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index cd4b5f7..8742736 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -16,15 +16,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <asm/cputime.h>
-#include <linux/cpufreq.h>
-#include <linux/cpumask.h>
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/workqueue.h>
 
 #include "cpufreq_governor.h"
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 0fe69f2..7db4373 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -18,10 +18,9 @@
 #define _CPUFREQ_GOVERNOR_H
 
 #include <linux/cpufreq.h>
-#include <linux/kobject.h>
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
-#include <linux/sysfs.h>
 
 /*
  * The polling frequency depends on the capability of the processor. Default
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 25438bb..232de60 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -12,20 +12,10 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/cpufreq.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/cpu.h>
 #include <linux/percpu-defs.h>
 #include <linux/slab.h>
-#include <linux/sysfs.h>
 #include <linux/tick.h>
-#include <linux/types.h>
-#include <linux/cpu.h>
-
 #include "cpufreq_governor.h"
 
 /* On-demand governor macros */
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index 9fef7d6..cf117de 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -12,10 +12,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 32109a1..e3b874c 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -12,10 +12,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cb38413..a7143b0 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -9,17 +9,10 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/sysfs.h>
 #include <linux/cpufreq.h>
 #include <linux/module.h>
-#include <linux/jiffies.h>
-#include <linux/percpu.h>
-#include <linux/kobject.h>
-#include <linux/spinlock.h>
-#include <linux/notifier.h>
+#include <linux/slab.h>
 #include <asm/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index f0d8741..f111454a 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -11,10 +11,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/cpufreq.h>
+#include <linux/module.h>
 
 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index e1fd215..97627bb 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,16 +11,11 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H
 
-#include <asm/cputime.h>
-#include <linux/mutex.h>
-#include <linux/notifier.h>
-#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/notifier.h>
 #include <linux/sysfs.h>
-#include <linux/completion.h>
-#include <linux/workqueue.h>
-#include <linux/cpumask.h>
-#include <asm/div64.h>
 
 #define CPUFREQ_NAME_LEN 16
 /* Print length for names. Extra 1 space for accomodating '\n' in prints */
-- 
1.7.12.rc2.18.g61b472e


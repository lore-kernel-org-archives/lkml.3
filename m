Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab3GaPgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:36:14 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51394 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab3GaPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:36:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Re-arrange header files
Date: Wed, 31 Jul 2013 21:05:57 +0530
Message-Id: <be0fa53fe03550ec49b8bade1af7d4e1f6e06b39.1375284946.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exercise has been done earlier but hasn't been done for few files. Lets do
it now. It targets to fix following problems:
- Include headers in ascending order, so that we don't add same multiple times
  by mistake.
- <asm/> must be included after <linux/>, so that they override whatever they
  need.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c             | 23 +++++++++++------------
 drivers/cpufreq/cpufreq_governor.c    |  2 +-
 drivers/cpufreq/cpufreq_ondemand.c    |  2 +-
 drivers/cpufreq/cpufreq_performance.c |  4 ++--
 drivers/cpufreq/cpufreq_powersave.c   |  4 ++--
 drivers/cpufreq/cpufreq_stats.c       | 12 ++++++------
 include/linux/cpufreq.h               | 10 +++++-----
 7 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 170d344..d5f2a09 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -17,25 +17,24 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <asm/cputime.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
-#include <linux/init.h>
+#include <linux/mutex.h>
 #include <linux/notifier.h>
-#include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/tick.h>
-#include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/cpu.h>
-#include <linux/completion.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
-
+#include <linux/tick.h>
 #include <trace/events/power.h>
+#include <asm/cputime.h>
 
 /**
  * The "cpufreq driver" - the arch- or hardware-dependent low
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 7409dbd..5876788 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -16,7 +16,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <asm/cputime.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
@@ -25,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <asm/cputime.h>
 
 #include "cpufreq_governor.h"
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index a3c5574..d3344b5 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -24,7 +25,6 @@
 #include <linux/sysfs.h>
 #include <linux/tick.h>
 #include <linux/types.h>
-#include <linux/cpu.h>
 
 #include "cpufreq_governor.h"
 
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index 9fef7d6..bdfda75 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -12,10 +12,10 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 32109a1..47235e2 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -12,10 +12,10 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index cb38413..7610e4b 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -9,17 +9,17 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/sysfs.h>
 #include <linux/cpufreq.h>
-#include <linux/module.h>
 #include <linux/jiffies.h>
-#include <linux/percpu.h>
+#include <linux/kernel.h>
 #include <linux/kobject.h>
-#include <linux/spinlock.h>
+#include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
 #include <asm/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index e1fd215..247d83a 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,15 +11,15 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H
 
-#include <asm/cputime.h>
+#include <linux/cpumask.h>
+#include <linux/completion.h>
+#include <linux/kobject.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
-#include <linux/threads.h>
-#include <linux/kobject.h>
 #include <linux/sysfs.h>
-#include <linux/completion.h>
+#include <linux/threads.h>
 #include <linux/workqueue.h>
-#include <linux/cpumask.h>
+#include <asm/cputime.h>
 #include <asm/div64.h>
 
 #define CPUFREQ_NAME_LEN 16
-- 
1.7.12.rc2.18.g61b472e


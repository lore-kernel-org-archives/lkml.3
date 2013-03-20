Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab3CTJak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:30:40 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64201 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3CTJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:30:37 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 30/30] compat: use backport_ prefix for main compat module calls
Date: Wed, 20 Mar 2013 02:22:55 -0700
Message-Id: <1363771375-31715-31-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 compat/compat-2.6.34.c        |    8 ++++----
 compat/compat-2.6.34.h        |    4 ++--
 compat/main.c                 |   25 +++++++++++++------------
 compat/pm_qos_params.c        |    4 ++--
 include/linux/compat-2.6.25.h |   10 +++++-----
 include/linux/compat-2.6.34.h |    6 ------
 include/linux/compat-2.6.36.h |    8 ++++----
 include/linux/compat-2.6.h    |    8 ++++----
 8 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/compat/compat-2.6.34.c b/compat/compat-2.6.34.c
index 7206007..4b23c81 100644
--- a/compat/compat-2.6.34.c
+++ b/compat/compat-2.6.34.c
@@ -12,16 +12,16 @@
 
 #include "compat-2.6.34.h"
 
-static mmc_pm_flag_t compat_mmc_pm_flags;
+static mmc_pm_flag_t backport_mmc_pm_flags;
 
-void init_compat_mmc_pm_flags(void)
+void backport_init_mmc_pm_flags(void)
 {
-	compat_mmc_pm_flags = 0;
+	backport_mmc_pm_flags = 0;
 }
 
 mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func)
 {
-	return compat_mmc_pm_flags;
+	return backport_mmc_pm_flags;
 }
 
 int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
diff --git a/compat/compat-2.6.34.h b/compat/compat-2.6.34.h
index 173fe52..b36b441 100644
--- a/compat/compat-2.6.34.h
+++ b/compat/compat-2.6.34.h
@@ -7,11 +7,11 @@
 
 #include <linux/mmc/sdio_func.h>
 
-void init_compat_mmc_pm_flags(void);
+void backport_init_mmc_pm_flags(void);
 
 #else /* Kernels >= 2.6.34 */
 
-static inline void init_compat_mmc_pm_flags(void)
+static inline void backport_init_mmc_pm_flags(void)
 {
 }
 
diff --git a/compat/main.c b/compat/main.c
index 972c142..4e72ca5 100644
--- a/compat/main.c
+++ b/compat/main.c
@@ -1,7 +1,8 @@
 #include <linux/module.h>
+#include "compat-2.6.34.h"
 
 MODULE_AUTHOR("Luis R. Rodriguez");
-MODULE_DESCRIPTION("Kernel compatibility module");
+MODULE_DESCRIPTION("Kernel backport module");
 MODULE_LICENSE("GPL");
 
 #ifndef COMPAT_BASE
@@ -41,17 +42,17 @@ module_param(compat_version, charp, 0400);
 MODULE_PARM_DESC(compat_version,
 		 "Version of the kernel compat backport work");
 
-void compat_dependency_symbol(void)
+void backport_dependency_symbol(void)
 {
 }
-EXPORT_SYMBOL_GPL(compat_dependency_symbol);
+EXPORT_SYMBOL_GPL(backport_dependency_symbol);
 
 
-static int __init compat_init(void)
+static int __init backport_init(void)
 {
-	compat_pm_qos_power_init();
-	compat_system_workqueue_create();
-	init_compat_mmc_pm_flags();
+	backport_pm_qos_power_init();
+	backport_system_workqueue_create();
+	backport_init_mmc_pm_flags();
 
 	printk(KERN_INFO
 	       COMPAT_PROJECT " backport release: "
@@ -65,14 +66,14 @@ static int __init compat_init(void)
 
         return 0;
 }
-module_init(compat_init);
+module_init(backport_init);
 
-static void __exit compat_exit(void)
+static void __exit backport_exit(void)
 {
-	compat_pm_qos_power_deinit();
-	compat_system_workqueue_destroy();
+	backport_pm_qos_power_deinit();
+	backport_system_workqueue_destroy();
 
         return;
 }
-module_exit(compat_exit);
+module_exit(backport_exit);
 
diff --git a/compat/pm_qos_params.c b/compat/pm_qos_params.c
index 833d98c..42785ce 100644
--- a/compat/pm_qos_params.c
+++ b/compat/pm_qos_params.c
@@ -414,7 +414,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 /*
  * This initializes pm-qos for older kernels.
  */
-int compat_pm_qos_power_init(void)
+int backport_pm_qos_power_init(void)
 {
 	int ret = 0;
 
@@ -442,7 +442,7 @@ int compat_pm_qos_power_init(void)
 	return ret;
 }
 
-int compat_pm_qos_power_deinit(void)
+int backport_pm_qos_power_deinit(void)
 {
 	int ret = 0;
 
diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 5d4fe38..a08e0b2 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -193,11 +193,11 @@ typedef u32 phys_addr_t;
  * This pm-qos implementation is copied verbatim from the kernel
  * written by mark gross mgross@linux.intel.com. You don't have
  * to do anythinig to use pm-qos except use the same exported
- * routines as used in newer kernels. The compat_pm_qos_power_init()
+ * routines as used in newer kernels. The backport_pm_qos_power_init()
  * defned below is used by the compat module to initialize pm-qos.
  */
-int compat_pm_qos_power_init(void);
-int compat_pm_qos_power_deinit(void);
+int backport_pm_qos_power_init(void);
+int backport_pm_qos_power_deinit(void);
 
 /*
  * 2.6.25 adds PM_EVENT_HIBERNATE as well here but
@@ -314,12 +314,12 @@ extern int strict_strtol(const char *, unsigned int, long *);
  * Kernels >= 2.6.25 have pm-qos and its initialized as part of
  * the bootup process
  */
-static inline int compat_pm_qos_power_init(void)
+static inline int backport_pm_qos_power_init(void)
 {
 	return 0;
 }
 
-static inline int compat_pm_qos_power_deinit(void)
+static inline int backport_pm_qos_power_deinit(void)
 {
 	return 0;
 }
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index c206633..09d5922 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -25,8 +25,6 @@ typedef unsigned int mmc_pm_flag_t;
 extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
 extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
 
-void init_compat_mmc_pm_flags(void);
-
 #define netdev_mc_count(dev) ((dev)->mc_count)
 #define netdev_mc_empty(dev) (netdev_mc_count(dev) == 0)
 
@@ -341,10 +339,6 @@ static inline struct sock *sk_entry(const struct hlist_node *node)
 
 #else /* Kernels >= 2.6.34 */
 
-static inline void init_compat_mmc_pm_flags(void)
-{
-}
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index b4d3761..d90b84f 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -161,8 +161,8 @@ extern struct workqueue_struct *system_long_wq;
 #define system_nrt_wq LINUX_BACKPORT(system_nrt_wq)
 extern struct workqueue_struct *system_nrt_wq;
 
-void compat_system_workqueue_create(void);
-void compat_system_workqueue_destroy(void);
+void backport_system_workqueue_create(void);
+void backport_system_workqueue_destroy(void);
 
 #define schedule_work LINUX_BACKPORT(schedule_work)
 int schedule_work(struct work_struct *work);
@@ -191,11 +191,11 @@ extern unsigned int work_busy(struct work_struct *work);
 
 #else
 
-static inline void compat_system_workqueue_create(void)
+static inline void backport_system_workqueue_create(void)
 {
 }
 
-static inline void compat_system_workqueue_destroy(void)
+static inline void backport_system_workqueue_destroy(void)
 {
 }
 
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index d1d24d0..5d75919 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -28,16 +28,16 @@
  * To the call to the initfn we added the symbol dependency on compat
  * to make sure that compat.ko gets loaded for any compat modules.
  */
-void compat_dependency_symbol(void);
+void backport_dependency_symbol(void);
 
 #undef module_init
 #define module_init(initfn)						\
-	static int __init __init_compat(void)				\
+	static int __init __init_backport(void)				\
 	{								\
-		compat_dependency_symbol();				\
+		backport_dependency_symbol();				\
 		return initfn();					\
 	}								\
-	int init_module(void) __attribute__((alias("__init_compat")));
+	int init_module(void) __attribute__((alias("__init_backport")));
 
 /*
  * Each compat file represents compatibility code for new kernel
-- 
1.7.10.4


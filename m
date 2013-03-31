Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3CaOcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 10:32:19 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46426 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3CaOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 10:32:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 1/4] workqueue: Add system wide system_freezable_unbound_wq
Date: Sun, 31 Mar 2013 20:01:44 +0530
Message-Id: <147bfb5aa81790f94df75858bf20570cbacc9dca.1364740180.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364740180.git.viresh.kumar@linaro.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364740180.git.viresh.kumar@linaro.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds system wide system_freezable_unbound_wq which will be used by
code that currently uses system_freezable_wq and can be moved to unbound
workqueues.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/workqueue.h | 4 ++++
 kernel/workqueue.c        | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 835d12b..ab7597b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -325,11 +325,15 @@ enum {
  *
  * system_freezable_wq is equivalent to system_wq except that it's
  * freezable.
+ *
+ * system_freezable_unbound_wq is equivalent to system_unbound_wq except that
+ * it's freezable.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
+extern struct workqueue_struct *system_freezable_unbound_wq;
 
 static inline struct workqueue_struct * __deprecated __system_nrt_wq(void)
 {
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index df2f6c4..771a5cc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -281,6 +281,8 @@ struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
+struct workqueue_struct *system_freezable_unbound_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_freezable_unbound_wq);
 
 static int worker_thread(void *__worker);
 static void copy_workqueue_attrs(struct workqueue_attrs *to,
@@ -4467,8 +4469,11 @@ static int __init init_workqueues(void)
 					    WQ_UNBOUND_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
 					      WQ_FREEZABLE, 0);
+	system_freezable_unbound_wq = alloc_workqueue("events_unbound_freezable",
+					      WQ_FREEZABLE | WQ_UNBOUND, 0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||
-	       !system_unbound_wq || !system_freezable_wq);
+	       !system_unbound_wq || !system_freezable_wq ||
+	       !system_freezable_unbound_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
-- 
1.7.12.rc2.18.g61b472e


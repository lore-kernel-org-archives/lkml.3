Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaEFRMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:12:14 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:13068 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbaEFRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:12:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8UAG8XaVNbtAAq/2dsb2JhbABZgwarbQQBAQEBAQEFAZoHAgKBHxd0glMTHCMYgQIkE4hFAa0doRiFVoh8hEYBA403gWSKGwGHZoMah3uDNjs
Date: Tue, 6 May 2014 19:12:05 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/kprobes.c: convert printk to pr_foo()
Message-Id: <20140506191205.49ca307736c06fa89c6b19cc@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes some checkpatch warnings
-Static initialization
-Lines over 80 characters

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/kprobes.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..15ea1f4 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -76,7 +76,7 @@ static bool kprobes_all_disarmed;
 
 /* This protects kprobe_table and optimizing_list */
 static DEFINE_MUTEX(kprobe_mutex);
-static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+static DEFINE_PER_CPU(struct kprobe *, kprobe_instance);
 static struct {
 	raw_spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
@@ -310,9 +310,9 @@ static inline void reset_kprobe_instance(void)
 
 /*
  * This routine is called either:
- * 	- under the kprobe_mutex - during kprobe_[un]register()
- * 				OR
- * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
+ *	- under the kprobe_mutex - during kprobe_[un]register()
+ *				OR
+ *	- with preemption disabled - from arch/xxx/kernel/kprobes.c
  */
 struct kprobe __kprobes *get_kprobe(void *addr)
 {
@@ -578,7 +578,8 @@ static __kprobes void wait_for_kprobe_optimizer(void)
 {
 	mutex_lock(&kprobe_mutex);
 
-	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
+	while (!list_empty(&optimizing_list) ||
+	       !list_empty(&unoptimizing_list)) {
 		mutex_unlock(&kprobe_mutex);
 
 		/* this will also make optimizing_work execute immmediately */
@@ -687,8 +688,8 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 	 */
 	op = container_of(ap, struct optimized_kprobe, kp);
 	if (unlikely(list_empty(&op->list)))
-		printk(KERN_WARNING "Warning: found a stray unused "
-			"aggrprobe@%p\n", ap->addr);
+		pr_warn("Warning: found a stray unused aggrprobe@%p\n",
+			ap->addr);
 	/* Enable the probe again */
 	ap->flags &= ~KPROBE_FLAG_DISABLED;
 	/* Optimize it again (remove from op->list) */
@@ -805,7 +806,7 @@ static void __kprobes optimize_all_kprobes(void)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
-	printk(KERN_INFO "Kprobes globally optimized\n");
+	pr_info("Kprobes globally optimized\n");
 out:
 	mutex_unlock(&kprobe_mutex);
 }
@@ -835,7 +836,7 @@ static void __kprobes unoptimize_all_kprobes(void)
 
 	/* Wait for unoptimizing completion */
 	wait_for_kprobe_optimizer();
-	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	pr_info("Kprobes globally unoptimized\n");
 }
 
 static DEFINE_MUTEX(kprobe_sysctl_mutex);
@@ -907,7 +908,7 @@ static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 /* There should be no unused kprobes can be reused without optimization */
 static void reuse_unused_kprobe(struct kprobe *ap)
 {
-	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	pr_err("Error: There should be no unused kprobe here.\n");
 	BUG_ON(kprobe_unused(ap));
 }
 
@@ -966,7 +967,8 @@ static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
 	}
 	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
 			   (unsigned long)p->addr, 1, 0);
-	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
+	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n",
+	     p->addr, ret);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 #define prepare_kprobe(p)	arch_prepare_kprobe(p)
@@ -1128,7 +1130,7 @@ __releases(hlist_lock)
 }
 
 static void __kprobes kretprobe_table_unlock(unsigned long hash,
-       unsigned long *flags)
+					     unsigned long *flags)
 __releases(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
@@ -1385,7 +1387,7 @@ static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
 	if (p != ap) {
 		list_for_each_entry_rcu(list_p, &ap->list, list)
 			if (list_p == p)
-			/* kprobe p is a valid probe */
+				/* kprobe p is a valid probe */
 				goto valid;
 		return NULL;
 	}
@@ -2014,8 +2016,8 @@ EXPORT_SYMBOL_GPL(enable_kprobe);
 
 void __kprobes dump_kprobe(struct kprobe *kp)
 {
-	printk(KERN_WARNING "Dumping kprobe:\n");
-	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
+	pr_warn("Dumping kprobe:\n");
+	pr_warn("Name: %s\nAddress: %p\nOffset: %x\n",
 	       kp->symbol_name, kp->addr, kp->offset);
 }
 
@@ -2107,7 +2109,7 @@ static int __init init_kprobes(void)
 			kprobe_lookup_name(kretprobe_blacklist[i].name,
 					   kretprobe_blacklist[i].addr);
 			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
+				pr_warn("kretprobe: lookup failed: %s\n",
 				       kretprobe_blacklist[i].name);
 		}
 	}
@@ -2249,7 +2251,7 @@ static void __kprobes arm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = false;
-	printk(KERN_INFO "Kprobes globally enabled\n");
+	pr_info("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -2271,7 +2273,7 @@ static void __kprobes disarm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = true;
-	printk(KERN_INFO "Kprobes globally disabled\n");
+	pr_info("Kprobes globally disabled\n");
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-- 
1.8.4.5


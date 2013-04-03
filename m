Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941Ab3DCIbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:31:18 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8736 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761582Ab3DCI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:29:19 -0400
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>
Subject: [PATCH 4/4] kprobes: replace printk with pr_-functions
Date: Wed, 3 Apr 2013 10:28:54 +0200
Message-ID: <1364977734-32267-5-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using printk use pr_info/pr_err/pr_warn. This was
detected by the checkpatch.pl script.

Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 kernel/kprobes.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3396eb8..03a9dd3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -168,7 +168,7 @@ static void init_kprobe_blacklist(void)
 			kprobe_lookup_name(kretprobe_blacklist[i].name,
 					   kretprobe_blacklist[i].addr);
 			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
+				pr_err("kretprobe: lookup failed: %s\n",
 				       kretprobe_blacklist[i].name);
 		}
 	}
@@ -777,7 +777,7 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 	 */
 	op = container_of(ap, struct optimized_kprobe, kp);
 	if (unlikely(list_empty(&op->list)))
-		printk(KERN_WARNING "Warning: found a stray unused "
+		pr_warn("Warning: found a stray unused "
 			"aggrprobe@%p\n", ap->addr);
 	/* Enable the probe again */
 	ap->flags &= ~KPROBE_FLAG_DISABLED;
@@ -884,7 +884,7 @@ static void __kprobes optimize_all_kprobes(void)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
-	printk(KERN_INFO "Kprobes globally optimized\n");
+	pr_info("Kprobes globally optimized\n");
 }
 
 /* This should be called with kprobe_mutex locked */
@@ -908,7 +908,7 @@ static void __kprobes unoptimize_all_kprobes(void)
 	}
 	/* Wait for unoptimizing completion */
 	wait_for_kprobe_optimizer();
-	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	pr_info("Kprobes globally unoptimized\n");
 }
 
 int sysctl_kprobes_optimization;
@@ -979,7 +979,7 @@ static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 /* There should be no unused kprobes can be reused without optimization */
 static void reuse_unused_kprobe(struct kprobe *ap)
 {
-	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	pr_err("Error: There should be no unused kprobe here.\n");
 	BUG_ON(kprobe_unused(ap));
 }
 
@@ -2093,8 +2093,8 @@ EXPORT_SYMBOL_GPL(enable_kprobe);
 
 void __kprobes dump_kprobe(struct kprobe *kp)
 {
-	printk(KERN_WARNING "Dumping kprobe:\n");
-	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
+	pr_warn("Dumping kprobe:\n");
+	pr_warn("Name: %s\nAddress: %p\nOffset: %x\n",
 	       kp->symbol_name, kp->addr, kp->offset);
 }
 
@@ -2290,7 +2290,7 @@ static void __kprobes arm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = false;
-	printk(KERN_INFO "Kprobes globally enabled\n");
+	pr_info("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -2312,7 +2312,7 @@ static void __kprobes disarm_all_kprobes(void)
 	}
 
 	kprobes_all_disarmed = true;
-	printk(KERN_INFO "Kprobes globally disabled\n");
+	pr_info("Kprobes globally disabled\n");
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-- 
1.8.1.5


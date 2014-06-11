Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaFKPrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:47:20 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:36116 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377AbaFKPrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:47:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugHAEt5mFNbslCP/2dsb2JhbABagw2sCAUBAQEBAQEFAZkbgQYXdYRgI4EaN4hGAc8EF4VciH2ESASPZIpKiyqIIYM+Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/test_kprobes.c: use current logging functions.
Date: Wed, 11 Jun 2014 17:46:00 +0200
Message-Id: <1402501560-7765-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Add pr_fmt
-Coalesce formats
-Use current pr_foo() functions instead of printk
-Remove unnecessary "failed" display (already in log level).

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/test_kprobes.c | 87 ++++++++++++++++++---------------------------------
 1 file changed, 31 insertions(+), 56 deletions(-)

diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index 12d6ebb..0dbab6d 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -14,6 +14,8 @@
  * the GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) "Kprobe smoke test: " fmt
+
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/random.h>
@@ -41,8 +43,7 @@ static void kp_post_handler(struct kprobe *p, struct pt_regs *regs,
 {
 	if (preh_val != (rand1 / div_factor)) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in post_handler\n");
+		pr_err("incorrect value in post_handler\n");
 	}
 	posth_val = preh_val + div_factor;
 }
@@ -59,8 +60,7 @@ static int test_kprobe(void)
 
 	ret = register_kprobe(&kp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kprobe returned %d\n", ret);
+		pr_err("register_kprobe returned %d\n", ret);
 		return ret;
 	}
 
@@ -68,14 +68,12 @@ static int test_kprobe(void)
 	unregister_kprobe(&kp);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler not called\n");
+		pr_err("kprobe pre_handler not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler not called\n");
+		pr_err("kprobe post_handler not called\n");
 		handler_errors++;
 	}
 
@@ -98,8 +96,7 @@ static void kp_post_handler2(struct kprobe *p, struct pt_regs *regs,
 {
 	if (preh_val != (rand1 / div_factor) + 1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in post_handler2\n");
+		pr_err("incorrect value in post_handler2\n");
 	}
 	posth_val = preh_val + div_factor;
 }
@@ -120,8 +117,7 @@ static int test_kprobes(void)
 	kp.flags = 0;
 	ret = register_kprobes(kps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kprobes returned %d\n", ret);
+		pr_err("register_kprobes returned %d\n", ret);
 		return ret;
 	}
 
@@ -130,14 +126,12 @@ static int test_kprobes(void)
 	ret = target(rand1);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler not called\n");
+		pr_err("kprobe pre_handler not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler not called\n");
+		pr_err("kprobe post_handler not called\n");
 		handler_errors++;
 	}
 
@@ -146,14 +140,12 @@ static int test_kprobes(void)
 	ret = target2(rand1);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler2 not called\n");
+		pr_err("kprobe pre_handler2 not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler2 not called\n");
+		pr_err("kprobe post_handler2 not called\n");
 		handler_errors++;
 	}
 
@@ -166,8 +158,7 @@ static u32 j_kprobe_target(u32 value)
 {
 	if (value != rand1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in jprobe handler\n");
+		pr_err("incorrect value in jprobe handler\n");
 	}
 
 	jph_val = rand1;
@@ -186,16 +177,14 @@ static int test_jprobe(void)
 
 	ret = register_jprobe(&jp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_jprobe returned %d\n", ret);
+		pr_err("register_jprobe returned %d\n", ret);
 		return ret;
 	}
 
 	ret = target(rand1);
 	unregister_jprobe(&jp);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler not called\n");
+		pr_err("jprobe handler not called\n");
 		handler_errors++;
 	}
 
@@ -217,24 +206,21 @@ static int test_jprobes(void)
 	jp.kp.flags = 0;
 	ret = register_jprobes(jps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_jprobes returned %d\n", ret);
+		pr_err("register_jprobes returned %d\n", ret);
 		return ret;
 	}
 
 	jph_val = 0;
 	ret = target(rand1);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler not called\n");
+		pr_err("jprobe handler not called\n");
 		handler_errors++;
 	}
 
 	jph_val = 0;
 	ret = target2(rand1);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler2 not called\n");
+		pr_err("jprobe handler2 not called\n");
 		handler_errors++;
 	}
 	unregister_jprobes(jps, 2);
@@ -256,13 +242,11 @@ static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 
 	if (ret != (rand1 / div_factor)) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in kretprobe handler\n");
+		pr_err("incorrect value in kretprobe handler\n");
 	}
 	if (krph_val == 0) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"call to kretprobe entry handler failed\n");
+		pr_err("call to kretprobe entry handler failed\n");
 	}
 
 	krph_val = rand1;
@@ -281,16 +265,14 @@ static int test_kretprobe(void)
 
 	ret = register_kretprobe(&rp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kretprobe returned %d\n", ret);
+		pr_err("register_kretprobe returned %d\n", ret);
 		return ret;
 	}
 
 	ret = target(rand1);
 	unregister_kretprobe(&rp);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler not called\n");
+		pr_err("kretprobe handler not called\n");
 		handler_errors++;
 	}
 
@@ -303,13 +285,11 @@ static int return_handler2(struct kretprobe_instance *ri, struct pt_regs *regs)
 
 	if (ret != (rand1 / div_factor) + 1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in kretprobe handler2\n");
+		pr_err("incorrect value in kretprobe handler2\n");
 	}
 	if (krph_val == 0) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"call to kretprobe entry handler failed\n");
+		pr_err("call to kretprobe entry handler failed\n");
 	}
 
 	krph_val = rand1;
@@ -332,24 +312,21 @@ static int test_kretprobes(void)
 	rp.kp.flags = 0;
 	ret = register_kretprobes(rps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kretprobe returned %d\n", ret);
+		pr_err("register_kretprobe returned %d\n", ret);
 		return ret;
 	}
 
 	krph_val = 0;
 	ret = target(rand1);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler not called\n");
+		pr_err("kretprobe handler not called\n");
 		handler_errors++;
 	}
 
 	krph_val = 0;
 	ret = target2(rand1);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler2 not called\n");
+		pr_err("kretprobe handler2 not called\n");
 		handler_errors++;
 	}
 	unregister_kretprobes(rps, 2);
@@ -368,7 +345,7 @@ int init_test_probes(void)
 		rand1 = prandom_u32();
 	} while (rand1 <= div_factor);
 
-	printk(KERN_INFO "Kprobe smoke test started\n");
+	pr_info("started\n");
 	num_tests++;
 	ret = test_kprobe();
 	if (ret < 0)
@@ -402,13 +379,11 @@ int init_test_probes(void)
 #endif /* CONFIG_KRETPROBES */
 
 	if (errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d out of "
-				"%d tests failed\n", errors, num_tests);
+		pr_err("BUG: %d out of %d tests failed\n", errors, num_tests);
 	else if (handler_errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d error(s) "
-				"running handlers\n", handler_errors);
+		pr_err("BUG: %d error(s) running handlers\n", handler_errors);
 	else
-		printk(KERN_INFO "Kprobe smoke test passed successfully\n");
+		pr_info("passed successfully\n");
 
 	return 0;
 }
-- 
1.8.4.5


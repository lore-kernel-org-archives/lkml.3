Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaGMVa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:30:27 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49469 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaGMVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:30:21 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] :kernel :acct :fix coding style warnings and errors
Date: Mon, 14 Jul 2014 00:30:51 +0300
Message-Id: <1405287051-12717-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style warnings and errors.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/acct.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 808a86f..1bfdda0 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -141,12 +141,12 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
 	if (acct->active) {
 		if (act < 0) {
 			acct->active = 0;
-			printk(KERN_INFO "Process accounting paused\n");
+			pr_info("Process accounting paused\n");
 		}
 	} else {
 		if (act > 0) {
 			acct->active = 1;
-			printk(KERN_INFO "Process accounting resumed\n");
+			pr_info("Process accounting resumed\n");
 		}
 	}
 
@@ -261,6 +261,7 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 
 	if (name) {
 		struct filename *tmp = getname(name);
+
 		if (IS_ERR(tmp))
 			return PTR_ERR(tmp);
 		error = acct_on(tmp);
@@ -376,7 +377,7 @@ static comp_t encode_comp_t(unsigned long value)
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -389,7 +390,7 @@ static comp_t encode_comp_t(unsigned long value)
 #define MANTSIZE2       20                      /* 20 bit mantissa. */
 #define EXPSIZE2        5                       /* 5 bit base 2 exponent. */
 #define MAXFRACT2       ((1ul << MANTSIZE2) - 1) /* Maximum fractional value. */
-#define MAXEXP2         ((1 <<EXPSIZE2) - 1)    /* Maximum exponent. */
+#define MAXEXP2         ((1 << EXPSIZE2) - 1)    /* Maximum exponent. */
 
 static comp2_t encode_comp2_t(u64 value)
 {
@@ -420,7 +421,7 @@ static comp2_t encode_comp2_t(u64 value)
 }
 #endif
 
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -429,8 +430,9 @@ static u32 encode_float(u64 value)
 	unsigned exp = 190;
 	unsigned u;
 
-	if (value==0) return 0;
-	while ((s64)value > 0){
+	if (value == 0)
+		return 0;
+	while ((s64)value > 0) {
 		value <<= 1;
 		exp--;
 	}
@@ -490,16 +492,17 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 		       + current->group_leader->start_time.tv_nsec;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_etime = encode_float(elapsed);
 #else
 	ac.ac_etime = encode_comp_t(elapsed < (unsigned long) -1l ?
-	                       (unsigned long) elapsed : (unsigned long) -1l);
+				(unsigned long) elapsed : (unsigned long) -1l);
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	{
 		/* new enlarged etime field */
 		comp2_t etime = encode_comp2_t(elapsed);
+
 		ac.ac_etime_hi = etime >> 16;
 		ac.ac_etime_lo = (u16) etime;
 	}
@@ -509,15 +512,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	/* we really need to bite the bullet and change layout */
 	ac.ac_uid = from_kuid_munged(file->f_cred->user_ns, orig_cred->uid);
 	ac.ac_gid = from_kgid_munged(file->f_cred->user_ns, orig_cred->gid);
-#if ACCT_VERSION==2
+#if ACCT_VERSION == 2
 	ac.ac_ahz = AHZ;
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
 #endif
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_pid = task_tgid_nr_ns(current, ns);
 	rcu_read_lock();
 	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
@@ -578,6 +581,7 @@ void acct_collect(long exitcode, int group_dead)
 
 	if (group_dead && current->mm) {
 		struct vm_area_struct *vma;
+
 		down_read(&current->mm->mmap_sem);
 		vma = current->mm->mmap;
 		while (vma) {
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbaLEErm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:47:42 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60318 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbaLEErl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:47:41 -0500
From: "Joshua I. James" <joshua@cybercrimetech.com>
X-Google-Original-From: "Joshua I. James" <Joshua@cybercrimetech.com>
To: linux-kernel@vger.kernel.org
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: kernel: fixed style warnings in acct.c
Date: Fri,  5 Dec 2014 13:47:34 +0900
Message-Id: <1417754854-6576-1-git-send-email-Joshua@cybercrimetech.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style errors identified by checkpatch.

Output of checkpatch:
WARNING: Missing a blank line after declarations
WARNING: line over 80 characters
ERROR: spaces required around that '==' (ctx:VxV)
+#if ACCT_VERSION==2

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 kernel/acct.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 33738ef..322159c 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -105,6 +105,7 @@ static int check_free_space(struct bsd_acct_struct *acct)
 
 	if (acct->active) {
 		u64 suspend = sbuf.f_blocks * SUSPEND;
+
 		do_div(suspend, 100);
 		if (sbuf.f_bavail <= suspend) {
 			acct->active = 0;
@@ -112,6 +113,7 @@ static int check_free_space(struct bsd_acct_struct *acct)
 		}
 	} else {
 		u64 resume = sbuf.f_blocks * RESUME;
+
 		do_div(resume, 100);
 		if (sbuf.f_bavail >= resume) {
 			acct->active = 1;
@@ -152,8 +154,10 @@ again:
 
 static void close_work(struct work_struct *work)
 {
-	struct bsd_acct_struct *acct = container_of(work, struct bsd_acct_struct, work);
+	struct bsd_acct_struct *acct =
+		container_of(work, struct bsd_acct_struct, work);
 	struct file *file = acct->file;
+
 	if (file->f_op->flush)
 		file->f_op->flush(file, NULL);
 	__fput_sync(file);
@@ -165,6 +169,7 @@ static void acct_kill(struct bsd_acct_struct *acct,
 {
 	if (acct) {
 		struct pid_namespace *ns = acct->ns;
+
 		do_acct_process(acct);
 		INIT_WORK(&acct->work, close_work);
 		init_completion(&acct->done);
@@ -182,6 +187,7 @@ static void acct_kill(struct bsd_acct_struct *acct,
 static void acct_pin_kill(struct fs_pin *pin)
 {
 	struct bsd_acct_struct *acct;
+
 	acct = container_of(pin, struct bsd_acct_struct, pin);
 	mutex_lock(&acct->lock);
 	if (!acct->ns) {
@@ -448,15 +454,17 @@ static void fill_ac(acct_t *ac)
 #endif
 	do_div(elapsed, AHZ);
 	ac->ac_btime = get_seconds() - elapsed;
-#if ACCT_VERSION==2
+#if ACCT_VERSION == 2
 	ac->ac_ahz = AHZ;
 #endif
 
 	spin_lock_irq(&current->sighand->siglock);
 	tty = current->signal->tty;	/* Safe as we hold the siglock */
 	ac->ac_tty = tty ? old_encode_dev(tty_devnum(tty)) : 0;
-	ac->ac_utime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_utime)));
-	ac->ac_stime = encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_stime)));
+	ac->ac_utime = encode_comp_t(jiffies_to_AHZ(
+		cputime_to_jiffies(pacct->ac_utime)));
+	ac->ac_stime = encode_comp_t(jiffies_to_AHZ(
+		cputime_to_jiffies(pacct->ac_stime)));
 	ac->ac_flag = pacct->ac_flag;
 	ac->ac_mem = encode_comp_t(pacct->ac_mem);
 	ac->ac_minflt = encode_comp_t(pacct->ac_minflt);
@@ -504,8 +512,8 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 
 		ac.ac_pid = task_tgid_nr_ns(current, ns);
 		rcu_read_lock();
-		ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
-					     ns);
+		ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(
+			current->real_parent), ns);
 		rcu_read_unlock();
 	}
 #endif
@@ -516,6 +524,7 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	if (file_start_write_trylock(file)) {
 		/* it's been opened O_APPEND, so position is irrelevant */
 		loff_t pos = 0;
+
 		__kernel_write(file, (char *)&ac, sizeof(acct_t), &pos);
 		file_end_write(file);
 	}
@@ -573,6 +582,7 @@ static void slow_acct_process(struct pid_namespace *ns)
 {
 	for ( ; ns; ns = ns->parent) {
 		struct bsd_acct_struct *acct = acct_get(ns);
+
 		if (acct) {
 			do_acct_process(acct);
 			mutex_unlock(&acct->lock);
-- 
1.9.1


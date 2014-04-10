Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030432AbaDJSy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:54:59 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35089 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbaDJSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:54:58 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz
Subject: [PATCH 13/15] kernel:acct: spaces required
Date: Thu, 10 Apr 2014 19:54:55 +0100
Message-Id: <1397156095-6929-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: spaces required around that '==' (ctx:VxV)

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 kernel/acct.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 808a86f..b936575 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -376,7 +376,7 @@ static comp_t encode_comp_t(unsigned long value)
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -420,7 +420,7 @@ static comp2_t encode_comp2_t(u64 value)
 }
 #endif
 
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -429,7 +429,7 @@ static u32 encode_float(u64 value)
 	unsigned exp = 190;
 	unsigned u;
 
-	if (value==0) return 0;
+	if (value == 0)
+		return 0;
 	while ((s64)value > 0){
 		value <<= 1;
 		exp--;
@@ -490,13 +490,13 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 		       + current->group_leader->start_time.tv_nsec;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_etime = encode_float(elapsed);
 #else
 	ac.ac_etime = encode_comp_t(elapsed < (unsigned long) -1l ?
 	                       (unsigned long) elapsed : (unsigned long) -1l);
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	{
 		/* new enlarged etime field */
 		comp2_t etime = encode_comp2_t(elapsed);
@@ -509,15 +509,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
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
-- 
1.8.3.2


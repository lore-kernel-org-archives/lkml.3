Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaHLIVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:21:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65111 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaHLIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:21:48 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel:async Fixed coding style issues.
Date: Tue, 12 Aug 2014 11:23:41 +0300
Message-Id: <1407831821-16078-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors and warning in kernel/async.c

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/async.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 61f023c..4c3773c 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -115,7 +115,7 @@ static void async_run_entry_fn(struct work_struct *work)
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+		pr_debug("calling  %lli_%pF @ %i\n",
 			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
@@ -124,7 +124,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
+		pr_debug("initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -285,7 +285,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
+		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -295,7 +295,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
+		pr_debug("async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
-- 
1.7.10.4


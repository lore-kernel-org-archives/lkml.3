Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaGNJ3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:29:19 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54970 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGNJ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:29:15 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: arjan@linux.intel, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel:async :changed printk to pr_debug to respect coding style.
Date: Mon, 14 Jul 2014 12:29:51 +0300
Message-Id: <1405330191-26211-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues by replacing printk with pr_debug.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/async.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 61f023c..c82276c 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -111,11 +111,12 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
+
 	ktime_t uninitialized_var(calltime), delta, rettime;
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+		pr_debug("calling  %lli_%pF @ %i\n",
 			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
@@ -124,7 +125,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
+		pr_debug("initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -285,7 +286,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
+		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -295,7 +296,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
+		pr_debug("async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
-- 
1.7.10.4


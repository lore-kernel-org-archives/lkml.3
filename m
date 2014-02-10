Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaBJN3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaBJN3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:37 -0500
Date: Mon, 10 Feb 2014 05:28:55 -0800
From: tip-bot for Johannes Berg <tipbot@zytor.com>
Message-ID: <tip-980f88e414418bf65569a3b62b08b07e6fc2f4c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, akpm@linux-foundation.org,
        johannes.berg@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, akpm@linux-foundation.org,
        johannes.berg@intel.com, tglx@linutronix.de
In-Reply-To: <1391704121.12789.20.camel@jlt4.sipsolutions.net>
References: <1391704121.12789.20.camel@jlt4.sipsolutions.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] sched/wait: Suppress Sparse '
 variable shadowing' warning
Git-Commit-ID: 980f88e414418bf65569a3b62b08b07e6fc2f4c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:29:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  980f88e414418bf65569a3b62b08b07e6fc2f4c6
Gitweb:     http://git.kernel.org/tip/980f88e414418bf65569a3b62b08b07e6fc2f4c6
Author:     Johannes Berg <johannes.berg@intel.com>
AuthorDate: Thu, 6 Feb 2014 17:28:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:11:49 +0100

sched/wait: Suppress Sparse 'variable shadowing' warning

This warning seems to show up a lot now, since ___wait_event()
is (indirectly) used inside wait_event_timeout(), which also
has a variable called __ret. Rename the one in ___wait_event()
to ___ret (another leading underscore) to suppress the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1391704121.12789.20.camel@jlt4.sipsolutions.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..c55ea5c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -195,7 +195,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long ___ret = ret;						\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
@@ -210,7 +210,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 			break;						\
 									\
 		if (___wait_is_interruptible(state) && __int) {		\
-			__ret = __int;					\
+			___ret = __int;					\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait,	\
 						     state, NULL);	\
@@ -222,7 +222,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
-__out:	__ret;								\
+__out:	___ret;								\
 })
 
 #define __wait_event(wq, condition)					\

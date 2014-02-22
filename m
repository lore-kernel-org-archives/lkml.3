Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaBVSEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:04:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaBVSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:04:22 -0500
Date: Sat, 22 Feb 2014 10:03:35 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-3ee237dddcd885d4e525791299d62de33b2ca117@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/prio: Add 3 macros of MAX_NICE,
  MIN_NICE and NICE_WIDTH in prio.h
Git-Commit-ID: 3ee237dddcd885d4e525791299d62de33b2ca117
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ee237dddcd885d4e525791299d62de33b2ca117
Gitweb:     http://git.kernel.org/tip/3ee237dddcd885d4e525791299d62de33b2ca117
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:14:13 +0100

sched/prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in prio.h

Currently there is lots of hard coding to 19 and -20, to represent
maximum and minimum of nice values.

This patch add three macros in prio.h for maximum, minimum and width
of nice value, and uses it to remove hardcoded values in prio.h.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ Collapsed two small patches. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 1ceaaa1..ac32258 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -1,6 +1,10 @@
 #ifndef _SCHED_PRIO_H
 #define _SCHED_PRIO_H
 
+#define MAX_NICE	19
+#define MIN_NICE	-20
+#define NICE_WIDTH	(MAX_NICE - MIN_NICE + 1)
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
@@ -17,8 +21,8 @@
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
 
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+#define MAX_PRIO		(MAX_RT_PRIO + NICE_WIDTH)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + NICE_WIDTH / 2)
 
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]

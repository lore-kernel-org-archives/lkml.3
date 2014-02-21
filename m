Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaBUVdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbaBUVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:33:49 -0500
Date: Fri, 21 Feb 2014 13:33:09 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-798fa741dd4e5a2d15e862367000a0ac63253978@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: prio: Add 3 macros of MAX_NICE,
  MIN_NICE and NICE_WIDTH in prio.h.
Git-Commit-ID: 798fa741dd4e5a2d15e862367000a0ac63253978
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

Commit-ID:  798fa741dd4e5a2d15e862367000a0ac63253978
Gitweb:     http://git.kernel.org/tip/798fa741dd4e5a2d15e862367000a0ac63253978
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:46 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

sched: prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in prio.h.

Currently, there are lots of hard coding of 19 and -20 to represent
maximum and minimum of nice value.

This patch add three macros in prio.h for maximum, minimum and width
of nice value.

cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched/prio.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 1ceaaa1..c6974c4 100644
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

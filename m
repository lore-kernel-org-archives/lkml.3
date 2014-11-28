Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaK1S1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:27:36 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52805 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaK1SYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:49 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 21/30] cputime: Remove task_cputime_t_scaled
Date: Fri, 28 Nov 2014 19:23:51 +0100
Message-Id: <1417199040-21044-22-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All readers of tsk->[us]timescaled have been converted to the new
nsec based cputime type.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/sched.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ce575e..659f068 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1920,19 +1920,6 @@ static inline void task_cputime_t(struct task_struct *t,
 		*stime = nsecs_to_cputime(st);
 }
 
-static inline void task_cputime_t_scaled(struct task_struct *t,
-					 cputime_t *utimescaled,
-					 cputime_t *stimescaled)
-{
-	u64 ut, st;
-
-	task_cputime_scaled(t, &ut, &st);
-	if (utimescaled)
-		*utimescaled = nsecs_to_cputime(ut);
-	if (stimescaled)
-		*stimescaled = nsecs_to_cputime(st);
-}
-
 extern void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
 
-- 
2.1.3


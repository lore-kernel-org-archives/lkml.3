Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3KWA6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:58:00 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5411 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3KWA4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:56:49 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com, davidlohr@hp.com
Subject: [PATCH 2/5] futex: Check for pi futex_q only once
Date: Fri, 22 Nov 2013 16:56:34 -0800
Message-Id: <1385168197-8612-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All wake_futex() callers already verify that the we are not dealing with
a pi futex_q, so we can remove the redundant WARN() check, as this is never
triggered anyway.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e6ffe73..0768c68 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -844,9 +844,6 @@ static void wake_futex(struct futex_q *q)
 {
 	struct task_struct *p = q->task;
 
-	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
-		return;
-
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
 	 * a non-futex wake up happens on another CPU then the task
-- 
1.8.1.4


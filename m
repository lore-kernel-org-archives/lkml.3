Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3ETQEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:04:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42578 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab3ETQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/8] nohz: Warn if the machine can not perform nohz_full
Date: Mon, 20 May 2013 18:01:49 +0200
Message-Id: <1369065716-22801-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

If the user configures NO_HZ_FULL and defines nohz_full=XXX on the
kernel command line, or enables NO_HZ_FULL_ALL, but nohz fails
due to the machine having a unstable clock, warn about it.

We do not want users thinking that they are getting the benefit
of nohz when their machine can not support it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bc67d42..cfc798b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -178,6 +178,11 @@ static bool can_stop_full_tick(void)
 	 */
 	if (!sched_clock_stable) {
 		trace_tick_stop(0, "unstable sched clock\n");
+		/*
+		 * Don't allow the user to think they can get
+		 * full NO_HZ with this machine.
+		 */
+		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3DXOpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:45:49 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48096 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3DXOpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:45:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] nohz: Fix unavailable tick_stop tracepoint in dynticks idle
Date: Wed, 24 Apr 2013 16:44:57 +0200
Message-Id: <1366814698-8260-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366814698-8260-1-git-send-email-fweisbec@gmail.com>
References: <1366814698-8260-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_tick_stop() tracepoint is only available in full
dynticks. But it's also used by dynticks-idle so let's build
it for the latter config as well.

This fixes:

     kernel/time/tick-sched.c: In function tick_nohz_stop_sched_tick:
     kernel/time/tick-sched.c:644: error: implicit declaration of function trace_tick_stop
     make[2]: *** [kernel/time/tick-sched.o] Erreur 1

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/trace/events/timer.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index f5eb53e..e967dd8 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -323,7 +323,7 @@ TRACE_EVENT(itimer_expire,
 		  (int) __entry->pid, (unsigned long long)__entry->now)
 );
 
-#ifdef CONFIG_NO_HZ_FULL
+#ifdef CONFIG_NO_HZ_COMMON
 TRACE_EVENT(tick_stop,
 
 	TP_PROTO(int success, char *error_msg),
-- 
1.7.5.4


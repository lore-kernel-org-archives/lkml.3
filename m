Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3HVH6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:58:51 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44947 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3HVH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:58:50 -0400
Message-ID: <5215C4B2.7050402@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:58:42 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/11] sched/cleanup: remove the extra parm of tick_nohz_start_idle()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082218-3568-0000-0000-0000041F075D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'cpu' has not been used, remove it to make code clean.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4b24d9e..6d24c5f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -436,7 +436,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 	sched_clock_idle_wakeup_event();
 }
 
-static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
@@ -752,7 +752,7 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 	ktime_t now, expires;
 	int cpu = smp_processor_id();
 
-	now = tick_nohz_start_idle(cpu, ts);
+	now = tick_nohz_start_idle(ts);
 
 	if (can_stop_idle_tick(cpu, ts)) {
 		int was_stopped = ts->tick_stopped;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaDUJ4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44724 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaDUJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:55:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 02/19] tick: update doc style comments for 'struct tick_sched'
Date: Mon, 21 Apr 2014 15:24:58 +0530
Message-Id: <77a497ec078788f772bbf696d456af9107c56a3b.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fields of 'struct tick_sched' didn't have a description in the kernel doc
style comment present above its declaration. Add them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 8c865fb..8cc804c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -35,14 +35,19 @@ enum tick_nohz_mode {
  * struct tick_sched - sched tick emulation and no idle tick control/stats
  * @sched_timer:	hrtimer to schedule the periodic tick in high
  *			resolution mode
+ * @check_clocks:	tracks if clockevent device is recently changed
+ * @nohz_mode:		Current NOHZ mode
  * @last_tick:		Store the last tick expiry time when the tick
  *			timer is modified for nohz sleeps. This is necessary
  *			to resume the tick timer operation in the timeline
  *			when the CPU returns from nohz sleep.
+ * @inidle:		CPU is currently executing from within the idle loop
  * @tick_stopped:	Indicator that the idle tick has been stopped
  * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
  * @idle_calls:		Total number of idle calls
  * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
+ * @idle_active:	similar to inidle, but is reset when we get an interrupt
+ *			while being in idle
  * @idle_entrytime:	Time when the idle call was entered
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
@@ -50,7 +55,10 @@ enum tick_nohz_mode {
  * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped,
  *			with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
- * @do_timer_lst:	CPU was the last one doing do_timer before going idle
+ * @last_jiffies:	Last updated value of jiffies
+ * @next_jiffies:	Next jiffie for which timer is requested
+ * @idle_expires:	Time when we should come out of idle or next timer event
+ * @do_timer_last:	CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
-- 
1.7.12.rc2.18.g61b472e


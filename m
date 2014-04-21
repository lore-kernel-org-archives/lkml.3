Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaDUJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:58:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64969 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaDUJ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 15/19] tick-sched: define 'delta' inside 'if' block in update_ts_time_stats()
Date: Mon, 21 Apr 2014 15:25:11 +0530
Message-Id: <731eed40967a674b1c2cf7f4428cbe195d78c0ca.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'delta' is used only inside the 'if' block and must be accessible within that.
So, move its definition inside the 'if' block.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c3aed50..8e75c13 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -412,10 +412,9 @@ static void
 update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now,
 		     u64 *last_update_time)
 {
-	ktime_t delta;
-
 	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
+		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+
 		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
 							 delta);
-- 
1.7.12.rc2.18.g61b472e


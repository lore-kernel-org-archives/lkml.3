Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaDNQi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:38:27 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36709 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbaDNQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:27 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 22/38] tick-sched: no need to recheck cpu_online() in can_stop_idle_tick()
Date: Mon, 14 Apr 2014 21:53:44 +0530
Message-Id: <74d448a200afd0424fb185e2fb2ac5c31fd6b205.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already checked if 'cpu' is online or not and so don't need to recheck
it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9cbba513..c81b6cf 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -716,7 +716,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (need_resched())
 		return false;
 
-	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
+	if (unlikely(local_softirq_pending())) {
 		static int ratelimit;
 
 		if (ratelimit < 10 &&
-- 
1.7.12.rc2.18.g61b472e


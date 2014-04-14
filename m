Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaDNQ1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49490 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 31/38] tick-sched: initialize 'ts' during its definition __tick_nohz_idle_enter()
Date: Mon, 14 Apr 2014 21:53:53 +0530
Message-Id: <618f2788ea8cba3e40ede4c45a9b1fb662a58c59.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 22b9505..f1bc258 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -792,7 +792,7 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
  */
 void tick_nohz_idle_enter(void)
 {
-	struct tick_sched *ts;
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -806,7 +806,6 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
-- 
1.7.12.rc2.18.g61b472e


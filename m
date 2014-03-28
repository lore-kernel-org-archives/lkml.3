Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaC1M06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:26:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43410 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaC1M05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:26:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 16/16] hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
Date: Fri, 28 Mar 2014 17:56:49 +0530
Message-Id: <3f690ebdc501ea2b6c8930a42598773b1d9b3188.1396009485.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <c2108011e02e39d0be889be658046e0de44f7c79.1396006658.git.viresh.kumar@linaro.org>
References: <c2108011e02e39d0be889be658046e0de44f7c79.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use base->hres_active directly when we already have a pointer to base instead of
calling hrtimer_hres_active(). As that would lead to:

	__this_cpu_read(hrtimer_bases.hres_active)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2: Removed few entries as hres_active isn't available if
CONFIG_HIGH_RES_TIMERS isn't enabled.

 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 83e5f2d..9e18145 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -883,7 +883,7 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Reprogram the clock event device. if enabled */
-	if (reprogram && hrtimer_hres_active() &&
+	if (reprogram && base->cpu_base->hres_active &&
 	    &timer->node == timerqueue_getnext(&base->active)) {
 		ktime_t expires;
 
-- 
1.7.12.rc2.18.g61b472e


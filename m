Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaCZLWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60013 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCZLWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 04/14] hrtimer: use base->index instead of basenum in switch_hrtimer_base()
Date: Wed, 26 Mar 2014 16:51:10 +0530
Message-Id: <535a552cd2c05a3ae2cb61da2583646e1c649699.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In switch_hrtimer_base() we have created a local variable basenum which is set
to base->index. This variable is used at only one place. It makes code more
readable if we remove this variable use base->index directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 95243f2..b0bcc10 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -202,11 +202,10 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
 	int cpu = get_nohz_timer_target(pinned);
-	int basenum = base->index;
 
 again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
-	new_base = &new_cpu_base->clock_base[basenum];
+	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
 		/*
-- 
1.7.12.rc2.18.g61b472e


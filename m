Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDDGww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:52:52 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:53247 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaDDGkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 10/36] hrtimer: use base->index instead of basenum in switch_hrtimer_base()
Date: Fri,  4 Apr 2014 12:05:53 +0530
Message-Id: <e68fe7a094852108be0d3f7bbb5194f0ed7d9cf5.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In switch_hrtimer_base() we have created a local variable basenum which is set
to base->index initially. This variable is used at only one place. It makes code
more readable if we remove this variable and use base->index directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3b29023..04e4c77 100644
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


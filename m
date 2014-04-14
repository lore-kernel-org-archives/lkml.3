Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaDNQ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:17 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51533 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaDNQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 20/38] tick-sched: initialize 'cpu' while defining it in tick_nohz_full_setup()
Date: Mon, 14 Apr 2014 21:53:42 +0530
Message-Id: <e753fa078bc151990115b693040f224e2329fd3b.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are doing this currently:

	int cpu;

	cpu = smp_processor_id();

And we can rewrite it to make it shorter:
	int cpu = smp_processor_id();

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 649b920..e9f9f87 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -274,7 +274,7 @@ out:
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
-	int cpu;
+	int cpu = smp_processor_id();
 
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
@@ -282,7 +282,6 @@ static int __init tick_nohz_full_setup(char *str)
 		return 1;
 	}
 
-	cpu = smp_processor_id();
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
 		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
 			   cpu);
-- 
1.7.12.rc2.18.g61b472e


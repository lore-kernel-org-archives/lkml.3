Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3IKLTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:19:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15006 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3IKLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:19:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Sep 2013 04:16:43 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 1/2] cpufreq: tegra: Remove not used header and clean up codes
Date: Wed, 11 Sep 2013 04:19:13 -0700
Message-ID: <1378898355-31290-2-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove inclustion of the not needed header files and remove the logic
to check the CPU ID to not exceeding the maximum supported CPUs.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/cpufreq/tegra-cpufreq.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index a7b876f..6eb3dd8 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA Corporation.
+ * Copyright (C) 2010-2013 Google, Inc.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
@@ -18,14 +19,9 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/clk.h>
-#include <linux/io.h>
 #include <linux/suspend.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
@@ -60,9 +56,6 @@ static unsigned int tegra_getspeed(unsigned int cpu)
 {
 	unsigned long rate;
 
-	if (cpu >= NUM_CPUS)
-		return 0;
-
 	rate = clk_get_rate(cpu_clk) / 1000;
 	return rate;
 }
@@ -209,9 +202,6 @@ static struct notifier_block tegra_cpu_pm_notifier = {
 
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
-	if (policy->cpu >= NUM_CPUS)
-		return -EINVAL;
-
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-- 
1.7.9.5


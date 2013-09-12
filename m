Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3ILLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:25:29 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10143 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3ILLZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:25:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Sep 2013 04:25:26 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 2/4] cpufreq: tegra: Remove not used header files and clean up codes
Date: Thu, 12 Sep 2013 04:24:49 -0700
Message-ID: <1378985091-9447-3-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the inclustion of the not needed header files and remove the
logic to check the CPU ID to not exceeding the maximum supported CPUs.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/cpufreq/tegra-cpufreq.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 09c5af0..c2d2910 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -18,14 +18,9 @@
 
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
@@ -40,14 +35,14 @@ static struct cpufreq_frequency_table freq_table[] = {
 	{ .frequency = CPUFREQ_TABLE_END },
 };
 
-#define NUM_CPUS	2
+#define MAX_CPUS	4
 
 static struct clk *cpu_clk;
 static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static unsigned long target_cpu_speed[NUM_CPUS];
+static unsigned long target_cpu_speed[MAX_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
 static bool is_suspended;
 
@@ -60,9 +55,6 @@ static unsigned int tegra_getspeed(unsigned int cpu)
 {
 	unsigned long rate;
 
-	if (cpu >= NUM_CPUS)
-		return 0;
-
 	rate = clk_get_rate(cpu_clk) / 1000;
 	return rate;
 }
@@ -209,9 +201,6 @@ static struct notifier_block tegra_cpu_pm_notifier = {
 
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
-	if (policy->cpu >= NUM_CPUS)
-		return -EINVAL;
-
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-- 
1.7.9.5


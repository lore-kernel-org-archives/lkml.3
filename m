Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3IMNNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:13:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65433 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3IMNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:13:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 089/228] cpufreq: tegra: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:35 +0530
Message-Id: <61fa7239e5848bfe69dbc86c09cc0e9bea9451b4.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index e014077..c36a8e7 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -51,11 +51,6 @@ static unsigned long target_cpu_speed[NUM_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
 static bool is_suspended;
 
-static int tegra_verify_speed(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, freq_table);
-}
-
 static unsigned int tegra_getspeed(unsigned int cpu)
 {
 	unsigned long rate;
@@ -237,19 +232,14 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct freq_attr *tegra_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver tegra_cpufreq_driver = {
-	.verify		= tegra_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= tegra_target,
 	.get		= tegra_getspeed,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
 	.name		= "tegra",
-	.attr		= tegra_cpufreq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int __init tegra_cpufreq_init(void)
-- 
1.7.12.rc2.18.g61b472e


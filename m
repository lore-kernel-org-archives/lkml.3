Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab3HHNxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:53:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42969 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965782Ab3HHNxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:53:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:37 +0530
Message-Id: <568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index cd66b85..b50d2c4 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -215,8 +215,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+	cpufreq_table_validate_and_show(policy, freq_table);
 	policy->cur = tegra_getspeed(policy->cpu);
 	target_cpu_speed[policy->cpu] = policy->cur;
 
@@ -233,7 +232,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
 	clk_disable_unprepare(emc_clk);
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e


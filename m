Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3HUOoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:44:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39123 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3HUOoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:44:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 11/14] cpufreq: s5pv210: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:30 +0530
Message-Id: <f34014dbefc4e4fbd01052648ff3a4ba67920311.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index efa1080..e3973da 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -511,9 +511,7 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	s5pv210_dram_conf[1].refresh = (__raw_readl(S5P_VA_DMC1 + 0x30) * 1000);
 	s5pv210_dram_conf[1].freq = clk_get_rate(dmc1_clk);
 
-	policy->cpuinfo.transition_latency = 40000;
-
-	return cpufreq_table_validate_and_show(policy, s5pv210_freq_table);
+	return cpufreq_generic_init(policy, s5pv210_freq_table, 40000);
 
 out_dmc1:
 	clk_put(dmc0_clk);
-- 
1.7.12.rc2.18.g61b472e


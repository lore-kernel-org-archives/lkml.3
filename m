Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab3IMNRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:17:13 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54784 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3IMNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:17:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 119/228] cpufreq: s5pv210: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:31:05 +0530
Message-Id: <de77e14bd1aa0e349a5a9f0beac3cbe3c604c909.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 0eafc52..30d9bb7 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -543,8 +543,6 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	s5pv210_dram_conf[1].refresh = (__raw_readl(S5P_VA_DMC1 + 0x30) * 1000);
 	s5pv210_dram_conf[1].freq = clk_get_rate(dmc1_clk);
 
-	policy->cur = policy->min = policy->max = s5pv210_getspeed(0);
-
 	policy->cpuinfo.transition_latency = 40000;
 
 	return cpufreq_table_validate_and_show(policy, s5pv210_freq_table);
-- 
1.7.12.rc2.18.g61b472e


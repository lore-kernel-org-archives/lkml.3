Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3DAM7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:59:07 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63816 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3DAM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:59:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 7/9] cpufreq: drivers: don't check range of target freq in .target()
Date: Mon,  1 Apr 2013 18:27:47 +0530
Message-Id: <c8744f720d5fd8f3312be7d40ae93f36a85ddcad.1364820621.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpufreq core checks the range of target_freq before calling driver->target() and
so we don't need to do it again.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/cpufreq.c  | 9 ---------
 drivers/cpufreq/dbx500-cpufreq.c | 6 ------
 2 files changed, 15 deletions(-)

diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 55eb870..8fb0c2a 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -79,15 +79,6 @@ static int davinci_target(struct cpufreq_policy *policy,
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
 	struct clk *armclk = cpufreq.armclk;
 
-	/*
-	 * Ensure desired rate is within allowed range.  Some govenors
-	 * (ondemand) will just pass target_freq=0 to get the minimum.
-	 */
-	if (target_freq < policy->cpuinfo.min_freq)
-		target_freq = policy->cpuinfo.min_freq;
-	if (target_freq > policy->cpuinfo.max_freq)
-		target_freq = policy->cpuinfo.max_freq;
-
 	freqs.old = davinci_getspeed(0);
 	freqs.new = clk_round_rate(armclk, target_freq * 1000) / 1000;
 
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 7192a6d..15ed367 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -37,12 +37,6 @@ static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int idx;
 	int ret;
 
-	/* scale the target frequency to one of the extremes supported */
-	if (target_freq < policy->cpuinfo.min_freq)
-		target_freq = policy->cpuinfo.min_freq;
-	if (target_freq > policy->cpuinfo.max_freq)
-		target_freq = policy->cpuinfo.max_freq;
-
 	/* Lookup the next frequency */
 	if (cpufreq_frequency_table_target(policy, freq_table, target_freq,
 					relation, &idx))
-- 
1.7.12.rc2.18.g61b472e


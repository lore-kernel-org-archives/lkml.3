Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3HWPzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:55:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35703 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3HWPzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:55:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel@list.st.com
Subject: [PATCH 14/16] cpufreq: spear: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:49 +0530
Message-Id: <a3f8237dc5b9e39ea4baf9b331a1036d2e66bf0e.1377272740.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

Cc: spear-devel@list.st.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index d9a8c5f..942393d 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -30,11 +30,6 @@ static struct {
 	u32 cnt;
 } spear_cpufreq;
 
-static unsigned int spear_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(spear_cpufreq.clk) / 1000;
-}
-
 static struct clk *spear1340_cpu_get_possible_parent(unsigned long newfreq)
 {
 	struct clk *sys_pclk;
@@ -156,6 +151,7 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 
 static int spear_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = spear_cpufreq.clk;
 	return cpufreq_generic_init(policy, spear_cpufreq.freq_tbl,
 			spear_cpufreq.transition_latency);
 }
@@ -165,7 +161,7 @@ static struct cpufreq_driver spear_cpufreq_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= spear_cpufreq_target,
-	.get		= spear_cpufreq_get,
+	.get		= cpufreq_generic_get,
 	.init		= spear_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
 	.attr		= cpufreq_generic_attr,
-- 
1.7.12.rc2.18.g61b472e


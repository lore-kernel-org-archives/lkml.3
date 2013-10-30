Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3J3Wxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:53:45 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47080 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3J3Wwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 13/16] cpufreq: spear: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:11 +0530
Message-Id: <f1849128586bb8e8d130a0a96630386182cc419e.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
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
index d02ccd1..5bed954 100644
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


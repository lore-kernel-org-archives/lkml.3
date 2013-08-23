Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3HWPxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:53:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37103 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3HWPxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:53:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 08/16] cpufreq: imx6q: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:43 +0530
Message-Id: <f7e59ddd611295eb1470ec044ae2a24985564ea2.1377272740.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 5efd9b7..52bb625 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -34,11 +34,6 @@ static struct device *cpu_dev;
 static struct cpufreq_frequency_table *freq_table;
 static unsigned int transition_latency;
 
-static unsigned int imx6q_get_speed(unsigned int cpu)
-{
-	return clk_get_rate(arm_clk) / 1000;
-}
-
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct opp *opp;
@@ -150,13 +145,14 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 
 static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = arm_clk;
 	return cpufreq_generic_init(policy, freq_table, transition_latency);
 }
 
 static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = imx6q_set_target,
-	.get = imx6q_get_speed,
+	.get = cpufreq_generic_get,
 	.init = imx6q_cpufreq_init,
 	.exit = cpufreq_generic_exit,
 	.name = "imx6q-cpufreq",
-- 
1.7.12.rc2.18.g61b472e


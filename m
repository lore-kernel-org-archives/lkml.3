Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab3IMNY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:24:29 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42618 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934070Ab3IMNYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:24:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 178/228] cpufreq: SPEAr: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:32:04 +0530
Message-Id: <ead8590bf7f5eba400289149c207906d39d8c3c3.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 2a03158..0326040 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -105,20 +105,16 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 }
 
 static int spear_cpufreq_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index)
 {
 	struct cpufreq_freqs freqs;
 	unsigned long newfreq;
 	struct clk *srcclk;
-	int index, ret, mult = 1;
-
-	if (cpufreq_frequency_table_target(policy, spear_cpufreq.freq_tbl,
-				target_freq, relation, &index))
-		return -EINVAL;
+	int ret, mult = 1;
 
 	freqs.old = spear_cpufreq_get(0);
-
 	newfreq = spear_cpufreq.freq_tbl[index].frequency * 1000;
+
 	if (of_machine_is_compatible("st,spear1340")) {
 		/*
 		 * SPEAr1340 is special in the sense that due to the possibility
@@ -179,7 +175,7 @@ static struct cpufreq_driver spear_cpufreq_driver = {
 	.name		= "cpufreq-spear",
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= spear_cpufreq_target,
+	.target_index	= spear_cpufreq_target,
 	.get		= spear_cpufreq_get,
 	.init		= spear_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e


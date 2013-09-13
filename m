Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab3IMNVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:21:54 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61060 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab3IMNVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:21:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 159/228] cpufreq: ia64: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:45 +0530
Message-Id: <1c9b241efbaa456013cc6b484bb17d9353aef340.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ia64-acpi-cpufreq.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 90c6598..4695fa2 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -227,26 +227,11 @@ acpi_cpufreq_get (
 static int
 acpi_cpufreq_target (
 	struct cpufreq_policy   *policy,
-	unsigned int target_freq,
-	unsigned int relation)
+	unsigned int index)
 {
-	struct cpufreq_acpi_io *data = acpi_io_data[policy->cpu];
-	unsigned int next_state = 0;
-	unsigned int result = 0;
-
-	pr_debug("acpi_cpufreq_setpolicy\n");
-
-	result = cpufreq_frequency_table_target(policy,
-			data->freq_table, target_freq, relation, &next_state);
-	if (result)
-		return (result);
-
-	result = processor_set_freq(data, policy, next_state);
-
-	return (result);
+	return processor_set_freq(acpi_io_data[policy->cpu], policy, index);
 }
 
-
 static int
 acpi_cpufreq_cpu_init (
 	struct cpufreq_policy   *policy)
@@ -379,7 +364,7 @@ acpi_cpufreq_cpu_exit (
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
 	.verify 	= cpufreq_generic_frequency_table_verify,
-	.target 	= acpi_cpufreq_target,
+	.target_index	= acpi_cpufreq_target,
 	.get 		= acpi_cpufreq_get,
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e


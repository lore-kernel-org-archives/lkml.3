Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3HJGs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:48:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42128 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3HJGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:48:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/44] cpufreq: acpi: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:05 +0530
Message-Id: <2f96344a6751bcbb8a59bbc5d34907d95ba1066b.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 75e829d..cd5badb 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -516,15 +516,6 @@ out:
 	return result;
 }
 
-static int acpi_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
-
-	pr_debug("acpi_cpufreq_verify\n");
-
-	return cpufreq_frequency_table_verify(policy, data->freq_table);
-}
-
 static unsigned long
 acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
 {
@@ -927,7 +918,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 };
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
-	.verify		= acpi_cpufreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= acpi_cpufreq_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= acpi_cpufreq_cpu_init,
-- 
1.7.12.rc2.18.g61b472e


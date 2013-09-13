Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3IMNLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:11:09 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56885 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab3IMNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:10:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 067/228] cpufreq: ia64-acpi: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:13 +0530
Message-Id: <770e811f81692f1321bd0fb8254f0f4a1b8671ff.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ia64-acpi-cpufreq.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 6cfad51..b958bdb 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -248,22 +248,6 @@ acpi_cpufreq_target (
 
 
 static int
-acpi_cpufreq_verify (
-	struct cpufreq_policy   *policy)
-{
-	unsigned int result = 0;
-	struct cpufreq_acpi_io *data = acpi_io_data[policy->cpu];
-
-	pr_debug("acpi_cpufreq_verify\n");
-
-	result = cpufreq_frequency_table_verify(policy,
-			data->freq_table);
-
-	return (result);
-}
-
-
-static int
 acpi_cpufreq_cpu_init (
 	struct cpufreq_policy   *policy)
 {
@@ -394,20 +378,14 @@ acpi_cpufreq_cpu_exit (
 }
 
 
-static struct freq_attr* acpi_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
-
 static struct cpufreq_driver acpi_cpufreq_driver = {
-	.verify 	= acpi_cpufreq_verify,
+	.verify 	= cpufreq_generic_frequency_table_verify,
 	.target 	= acpi_cpufreq_target,
 	.get 		= acpi_cpufreq_get,
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
 	.name		= "acpi-cpufreq",
-	.attr           = acpi_cpufreq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 
-- 
1.7.12.rc2.18.g61b472e


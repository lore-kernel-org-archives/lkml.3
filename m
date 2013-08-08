Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360Ab3HHOKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:10:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52942 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3HHNta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:49:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/35] cpufreq: acpi-cpufreq: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:07 +0530
Message-Id: <01b9e673a0f3791720ef0f0b66d6ffc2dd331219.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 9b5d1b1..75e829d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -837,7 +837,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	data->freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
 	perf->state = 0;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table);
+	result = cpufreq_table_validate_and_show(policy, data->freq_table);
 	if (result)
 		goto err_freqfree;
 
@@ -868,8 +868,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 			(u32) perf->states[i].power,
 			(u32) perf->states[i].transition_latency);
 
-	cpufreq_frequency_table_get_attr(data->freq_table, policy->cpu);
-
 	/*
 	 * the first call to ->target() should result in us actually
 	 * writing something to the appropriate registers.
-- 
1.7.12.rc2.18.g61b472e


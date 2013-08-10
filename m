Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3HJGsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:48:04 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50800 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161Ab3HJGr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:47:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 02/44] cpufreq: blackfin: call cpufreq_frequency_table_put_attr()
Date: Sat, 10 Aug 2013 12:13:58 +0530
Message-Id: <c930ff044ef1d7c88c64ea5f9c665145216bfbef.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers which have an exit path must call cpufreq_frequency_table_put_attr() if
they have called cpufreq_frequency_table_get_attr() in their init path.

This driver was missing this part and is fixed with this patch.

Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 54c0a0c..84d446a 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -213,6 +213,12 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, bfin_freq_table);
 }
 
+static int __bfin_cpu_exit(struct cpufreq_policy *policy)
+{
+
+	cpufreq_frequency_table_put_attr(policy->cpu);
+}
+
 static struct freq_attr *bfin_freq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
 	NULL,
@@ -223,6 +229,7 @@ static struct cpufreq_driver bfin_driver = {
 	.target = bfin_target,
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
+	.exit = __bfin_cpu_exit,
 	.name = "bfin cpufreq",
 	.attr = bfin_freq_attr,
 };
-- 
1.7.12.rc2.18.g61b472e


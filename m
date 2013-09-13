Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3IMNH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:07:29 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50770 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3IMNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:07:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 036/228] cpufreq: s3cx4xx: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:42 +0530
Message-Id: <9ddc49beb2de6aeadf36340ca3ce909ff06a7952.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c2416-cpufreq.c | 4 +---
 drivers/cpufreq/s3c24xx-cpufreq.c | 6 ++----
 drivers/cpufreq/s3c64xx-cpufreq.c | 5 +----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 22dcb81..a7a4c61 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -494,12 +494,10 @@ static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = (500 * 1000) +
 					     s3c_freq->regulator_latency;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, s3c_freq->freq_table);
+	ret = cpufreq_table_validate_and_show(policy, s3c_freq->freq_table);
 	if (ret)
 		goto err_freq_table;
 
-	cpufreq_frequency_table_get_attr(s3c_freq->freq_table, 0);
-
 	register_reboot_notifier(&s3c2416_cpufreq_reboot_notifier);
 
 	return 0;
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index f2c872c..73856d1 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -386,10 +386,8 @@ static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 	/* feed the latency information from the cpu driver */
 	policy->cpuinfo.transition_latency = cpu_cur.info->latency;
 
-	if (ftab) {
-		cpufreq_frequency_table_cpuinfo(policy, ftab);
-		cpufreq_frequency_table_get_attr(ftab, policy->cpu);
-	}
+	if (ftab)
+		return cpufreq_table_validate_and_show(policy, ftab);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 9024043..872f74d 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -251,15 +251,12 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 	 */
 	policy->cpuinfo.transition_latency = (500 * 1000) + regulator_latency;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, s3c64xx_freq_table);
+	ret = cpufreq_table_validate_and_show(policy, s3c64xx_freq_table);
 	if (ret != 0) {
 		pr_err("Failed to configure frequency table: %d\n",
 		       ret);
 		regulator_put(vddarm);
 		clk_put(armclk);
-	} else {
-		cpufreq_frequency_table_get_attr(s3c64xx_freq_table,
-				policy->cpu);
 	}
 
 	return ret;
-- 
1.7.12.rc2.18.g61b472e


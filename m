Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282Ab3HHNtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:49:20 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33642 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252Ab3HHNtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:49:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 03/35] cpufreq: s3cx4xx: call cpufreq_frequency_table_get_attr()
Date: Thu,  8 Aug 2013 19:18:05 +0530
Message-Id: <4af1a6a5a2d952f0a2ca641109ba185b346dfe5d.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exposes frequency table of driver to cpufreq core and is required for core
to guess what the index for a target frequency is, when it calls
cpufreq_frequency_table_target(). And so this driver needs to expose it.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c24xx-cpufreq.c | 4 +++-
 drivers/cpufreq/s3c64xx-cpufreq.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index f169ee5..8843454 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -386,8 +386,10 @@ static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 	/* feed the latency information from the cpu driver */
 	policy->cpuinfo.transition_latency = cpu_cur.info->latency;
 
-	if (ftab)
+	if (ftab) {
 		cpufreq_frequency_table_cpuinfo(policy, ftab);
+		cpufreq_frequency_table_get_attr(ftab, policy->cpu);
+	}
 
 	return 0;
 }
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 8a72b0c..9024043 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -257,6 +257,9 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		       ret);
 		regulator_put(vddarm);
 		clk_put(armclk);
+	} else {
+		cpufreq_frequency_table_get_attr(s3c64xx_freq_table,
+				policy->cpu);
 	}
 
 	return ret;
-- 
1.7.12.rc2.18.g61b472e


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3IMNIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:08:48 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37380 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3IMNIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 048/228] cpufreq: arm_big_little: call cpufreq_frequency_table_put_attr()
Date: Fri, 13 Sep 2013 18:29:54 +0530
Message-Id: <38dc2874eabe153bbe4a042d15746c3c62913eb3.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers which have an exit path must call cpufreq_frequency_table_put_attr() if
they have called cpufreq_frequency_table_get_attr() in their init path.

This driver was missing this part and is fixed with this patch.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 8cb6dbc..2c7c134 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -198,6 +198,7 @@ static int bL_cpufreq_exit(struct cpufreq_policy *policy)
 		return -ENODEV;
 	}
 
+	cpufreq_frequency_table_put_attr(policy->cpu);
 	put_cluster_clk_and_freq_table(cpu_dev);
 	dev_dbg(cpu_dev, "%s: Exited, cpu: %d\n", __func__, policy->cpu);
 
-- 
1.7.12.rc2.18.g61b472e


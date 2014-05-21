Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEULLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:11:18 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:59476 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaEULLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:11:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 7/7] cpufreq: exynos5440: don't initialize opp table
Date: Wed, 21 May 2014 16:40:05 +0530
Message-Id: <09ed496bfe585eb8e19150dfd64c778016dfb7de.1400670427.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP tables are already initialized for CPU0 by cpufreq core and so we don't need
to reinitialize them from exynos5440's driver.

Cd: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cd: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos5440-cpufreq.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index f33f25b..72a4206 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -360,12 +360,6 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_put_node;
 	}
 
-	ret = of_init_opp_table(dvfs_info->dev);
-	if (ret) {
-		dev_err(dvfs_info->dev, "failed to init OPP table: %d\n", ret);
-		goto err_put_node;
-	}
-
 	ret = dev_pm_opp_init_cpufreq_table(dvfs_info->dev,
 					    &dvfs_info->freq_table);
 	if (ret) {
-- 
2.0.0.rc2


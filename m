Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaESGS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:18:29 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34164 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaESGS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:18:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 4/5] cpufreq: cpufreq-cpu0: don't initialize opp table
Date: Mon, 19 May 2014 11:47:24 +0530
Message-Id: <fa7641040b8c27b726aac8f59bfbc653c41d38ce.1400480033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP tables are already initialized for CPU0 by cpufreq core and so we don't need
to reinitialize them from cpufreq-cpu0 driver.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 1bf6bba..4301c7c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -152,12 +152,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_node;
 	}
 
-	ret = of_init_opp_table(cpu_dev);
-	if (ret) {
-		pr_err("failed to init OPP table: %d\n", ret);
-		goto out_put_node;
-	}
-
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		pr_err("failed to init cpufreq table: %d\n", ret);
-- 
2.0.0.rc2


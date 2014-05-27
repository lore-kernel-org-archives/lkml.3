Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaE0Lxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:53:31 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38478 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaE0Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:53:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 7/8] cpufreq: cpufreq-cpu0: don't initialize opp table
Date: Tue, 27 May 2014 17:20:56 +0530
Message-Id: <9460613606cb33b6559e6106b5692e32b80e5631.1401191054.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1401191054.git.viresh.kumar@linaro.org>
References: <cover.1401191054.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1401191054.git.viresh.kumar@linaro.org>
References: <cover.1401191054.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU OPP tables are already initialized by CPU core and we don't need to
reinitialize them from cpufreq-cpu0 driver.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
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


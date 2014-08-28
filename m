Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbaH0S2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:28:23 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:34076 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964838AbaH0S2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:28:21 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: cpu0: Release clk and regulator in remove function
Date: Thu, 28 Aug 2014 00:00:10 -0700
Message-Id: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function releases clk and regulator in remove function for clean
unloading.

CC: Shawn Guo <shawn.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 0d2172b..e1574f8 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -229,6 +229,8 @@ static int cpu0_cpufreq_remove(struct platform_device *pdev)
 	cpufreq_cooling_unregister(cdev);
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
+	clk_put(cpu_clk);
+	regulator_put(cpu_reg);
 
 	return 0;
 }
-- 
1.7.0.4


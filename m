Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900AbaH0S23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:28:29 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:59731 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964876AbaH0S2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:28:25 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] cpufreq: cpu0: Removes unnecessary IS_ERR check on clk
Date: Thu, 28 Aug 2014 00:00:11 -0700
Message-Id: <1409209212-18730-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes unnecessary IS_ERR check on clk when in failure path
as execution wont reach till there with clk being a err.

CC: Shawn Guo <shawn.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index e1574f8..0652cea 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -214,8 +214,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 out_free_table:
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_put_clk:
-	if (!IS_ERR(cpu_clk))
-		clk_put(cpu_clk);
+	clk_put(cpu_clk);
 out_put_reg:
 	if (!IS_ERR(cpu_reg))
 		regulator_put(cpu_reg);
-- 
1.7.0.4


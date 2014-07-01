Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbaGAQeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:34:18 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56712 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbaGAQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:34:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/14] cpufreq: cpu0: don't validate clock on clk_put()
Date: Tue,  1 Jul 2014 22:02:34 +0530
Message-Id: <a5279afda849ca394552dbae6a1364769da0dc98.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU clk is not optional for this driver and probe would fail if it couldn't find
a suitable clock.

And so, while calling clk_put() we don't need to validate clocks.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 7e191db..4273a5f 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -220,8 +220,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
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
2.0.0.rc2


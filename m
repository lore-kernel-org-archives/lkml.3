Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3ECEog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:44:36 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40447 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3ECEoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:44:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        shawn.guo@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] cpufreq: cpu0: Free parent node for error cases
Date: Fri,  3 May 2013 10:14:25 +0530
Message-Id: <03c6b0e0f41238c1b4346b4186040ff69e369b4a.1367556239.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are freeing parent node in success cases but not in failure cases. Lets do
it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 3ab8294..8565d41 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	if (!np) {
 		pr_err("failed to find cpu0 node\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out_put_parent;
 	}
 
 	cpu_dev = &pdev->dev;
@@ -264,6 +265,8 @@ out_free_table:
 	opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_put_node:
 	of_node_put(np);
+out_put_parent:
+	of_node_put(parent);
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e


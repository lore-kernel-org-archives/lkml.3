Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3IMNJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:09:03 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43429 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab3IMNI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 050/228] cpufreq: exynos: call cpufreq_frequency_table_put_attr()
Date: Fri, 13 Sep 2013 18:29:56 +0530
Message-Id: <9c9521dc5cea729915ad890a6fe8ffed39fa1a7e.1379063063.git.viresh.kumar@linaro.org>
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

Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos5440-cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 83bd700..e041f5e 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -342,12 +342,18 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
+static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+}
+
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= exynos_verify_speed,
 	.target		= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
+	.exit		= exynos_cpufreq_cpu_exit,
 	.name		= CPUFREQ_NAME,
 };
 
-- 
1.7.12.rc2.18.g61b472e


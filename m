Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbaHQEG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 00:06:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57672 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaHQEG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 00:06:26 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: viresh.kumar@linaro.org
Cc: rjw@rjwysocki.net, kgene.kim@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: exynos: free memory immediately on unknown SoC
Date: Sun, 17 Aug 2014 09:36:14 +0530
Message-Id: <1408248374-1638-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/cpufreq/exynos-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 1e0ec57..e47d165 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -178,6 +178,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		ret = exynos5250_cpufreq_init(exynos_info);
 	} else {
 		pr_err("%s: Unknown SoC type\n", __func__);
+		kfree(exynos_info);
 		return -ENODEV;
 	}
 
-- 
1.7.11.7


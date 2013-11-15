Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3KOLoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:44:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39369 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3KOLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:43:46 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-pm@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, tomasz.figa@gmail.com, yadi.brar01@gmail.com,
        sachin.kamat@linaro.org, myungjoo.ham@samsung.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC v2 4/4] ARM: SAMSUNG: Register static platform device for ASV for Exynos5
Date: Fri, 15 Nov 2013 17:11:31 +0530
Message-Id: <1384515691-26299-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yadwinder Singh Brar <yadi.brar@samsung.com>

Since ASV is not a hardware controller, we can't add device tree node
for it. This patch registers a static platform device for Exynos ASV.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mach-exynos/mach-exynos5-dt.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 602c5d7111d0..831b7222aab6 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -24,6 +24,7 @@ static void __init exynos5_dt_machine_init(void)
 	struct device_node *i2c_np;
 	const char *i2c_compat = "samsung,s3c2440-i2c";
 	unsigned int tmp;
+	struct platform_device_info devinfo = { .name = "exynos-asv", };
 
 	/*
 	 * Exynos5's legacy i2c controller and new high speed i2c
@@ -47,6 +48,7 @@ static void __init exynos5_dt_machine_init(void)
 	exynos_cpufreq_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	platform_device_register_full(&devinfo);
 }
 
 static char const *exynos5_dt_compat[] __initdata = {
-- 
1.7.9.5


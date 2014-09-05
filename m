Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaIENwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35537 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbaIENwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:38 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f9-5409c0243329
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 5/5] ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12
 SoCs
Date: Fri, 05 Sep 2014 15:51:28 +0200
Message-id: <1409925088-4705-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAV2VA5whBs3H+Sw2zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi41cPBx6P
	O9f2sHlsXlLvcfvfY2aPLVfbWTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY/35m8wF87gr
	NqwLaGA8ydnFyMEhIWAice2JQRcjJ5ApJnHh3nq2LkYuDiGBRYwSHQu3sEM4XUwSPy+sYAep
	YhOwkpjYvooRxBYRUJPoWbyVEaSIWWA2s8Srhw9YQKYKC4RK3JpgCmKyCKhK7H0jC1LOK+Au
	MfPpARaIZYoS3c8msIHYnAIeElMefGEGsYWAanZ232SZwMi7gJFhFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwGD6T2sG4ssHiEKMAB6MSD++CzxwhQqyJZcWVuYcYJTiYlUR4bXdzhgjx
	piRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgFDF5JXMqcrv4
	2aT9mlUnnJs3cd65vv2N0be7H15btz8SXmA6l+Hja7fr5dp8fltnaDcGhf60Onyw2kfrt5C6
	6d+7J8v+l05fxPWNwyx2c8HVshVWRnqtMkcfyW6+/u8Up+P0pOOtsmZJ14L1T+i1qt64HrS+
	K715FafI3iUKp50DFT1O1bv3KbEUZyQaajEXFScCAFB7lik/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register cpuidle platform device on Exynos4x12 SoCs allowing EXYNOS
cpuidle driver usage on these SoCs.

AFTR mode reduces power consumption on Trats2 board (Exynos4412 SoC
with secure firmware enabled) by ~12% when EXYNOS cpuidle driver is
enabled (in both cases the default exynos_defconfig config is used
and CPU1-3 are offlined).

Currently Exynos4412 SoC support is limited to Trats2 board.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v6:
- limit Exynos4412 SoC support to Trats2 board for now

 arch/arm/mach-exynos/exynos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 6a24e11..f5a78d7 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -317,7 +317,10 @@ static void __init exynos_dt_machine_init(void)
 		exynos_sysram_init();
 
 	if (of_machine_is_compatible("samsung,exynos4210") ||
-			of_machine_is_compatible("samsung,exynos5250"))
+	    of_machine_is_compatible("samsung,exynos4212") ||
+	    (of_machine_is_compatible("samsung,exynos4412") &&
+	     of_machine_is_compatible("samsung,trats2")) ||
+	    of_machine_is_compatible("samsung,exynos5250"))
 		platform_device_register(&exynos_cpuidle);
 
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-- 
1.8.2.3


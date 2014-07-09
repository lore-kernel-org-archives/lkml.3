Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaGIRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:19:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGIRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:19:16 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7f-53bd79935d9f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 4/4] ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12
 SoCs
Date: Wed, 09 Jul 2014 19:17:54 +0200
Message-id: <1404926274-18411-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd3JlXuDDX4+FrDYOGM9q8W8z7IW
	vQuuslmcbXrDbvH+0DNmi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnV4uSfXkaL9TNes1hs
	/OrhwOtx59oeNo/NS+o9bv97zOyx5Wo7i0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBlfF25
	lbHgAkfF68lzmBoYF7F3MXJySAiYSFy5eZYZwhaTuHBvPVsXIxeHkMAiRolFuz9COV1MEtPb
	1oFVsQlYSUxsX8UIYosIqEn0LN7KCFLELLCXWWJp9yawscICoRId2x8zgdgsAqoSCw7eB2vm
	FfCQ2L5jHhvEOkWJ7mcTgGwODk4BT4lnW4tBwkJAJWeftTNNYORdwMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4LJ9J72Bc1WBxiFGAg1GJh1eBZ0+wEGtiWXFl7iFGCQ5mJRHeWyV7
	g4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwyr69t/9O
	5gnzvx1TImQlLA04b8W/25v4fo+D/ou6IjmZJ80OM4VMm1hN507p/rvzPwN73glGZsWzWYGS
	E3SjulskX67lbjjOd7ao11dzht2hySt1Zt8qf7PYNsBaWDTvg/KLM+tf74suc9+811rV3Tp0
	f84+ppMCN5KuNJddOL70afDqM7dWKrEUZyQaajEXFScCAKUaCedHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register cpuidle platform device on Exynos4x12 SoCs allowing EXYNOS
cpuidle driver usage on these SoCs.

AFTR mode reduces power consumption on Trats2 board (Exynos4412 SoC
with secure firmware enabled) by ~12% when EXYNOS cpuidle driver is
enabled (in both cases the default exynos_defconfig config is used
and CPU1-3 are offlined).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v3:
- new patch

 arch/arm/mach-exynos/exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 4361abd..23003d9 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -173,7 +173,8 @@ static struct platform_device exynos_cpuidle = {
 
 void __init exynos_cpuidle_init(void)
 {
-	if (soc_is_exynos4210() || soc_is_exynos5250())
+	if (soc_is_exynos4210() || soc_is_exynos4212() ||
+	    soc_is_exynos4412() || soc_is_exynos5250())
 		platform_device_register(&exynos_cpuidle);
 }
 
-- 
1.8.2.3


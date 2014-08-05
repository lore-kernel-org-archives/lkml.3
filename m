Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaHENfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:35:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64319 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaHENfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:35:02 -0400
X-AuditID: cbfee61b-f79f86d00000144c-58-53e0dd84efd4
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
Subject: [PATCH v5 5/5] ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12
 SoCs
Date: Tue, 05 Aug 2014 15:34:26 +0200
Message-id: <1407245666-20016-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAd3Wuw+CDdaaWGycsZ7VYt5nWYve
	BVfZLM42vWG3eH/oGbPFpsfXWC0u75rDZvG59wijxYzz+5gszpy+xGpx8k8vo8X6Ga9ZLDZ+
	9XDg9bhzbQ+bx+Yl9R63/z1m9thytZ3Fo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDI2XbnB
	VPCUs2LXl0dMDYxbOLoYOTgkBEwkFlyM6GLkBDLFJC7cW8/WxcjFISSwiFHi7dNj7BBOF5PE
	/W1/WUCq2ASsJCa2r2IEsUUE1CR6Fm9lBCliFtjLLLG0exM7SEJYIFSi/fceRpANLAKqEu3L
	mEHCvAIeEpu+n2eD2KYo0f1sApjNKeAp0XjtGViNEFDN5iu7mSYw8i5gZFjFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERySz6R3MK5qsDjEKMDBqMTDK6B2P1iINbGsuDL3EKMEB7OSCC/7
	7QfBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhi7Jdqa
	v/5l/7bB9y2nfr+RRmRgfs6kta+eGd1I+tG/3V/qubWaeoXSvE6p+taVUxtZ5C24OYs8PHvq
	NBubrZ6tM5VLXurh//hIz5KaJcyJJcel3n/YuqVLgCu+UnvqX6vVlRZyO7++y/DKi1jFn3x0
	8t5UrhnGK5kPr3FWm56dvMn2yfmnL5RYijMSDbWYi4oTASzIcUZFAgAA
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
 arch/arm/mach-exynos/exynos.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 6a24e11..15cf86d 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -317,7 +317,9 @@ static void __init exynos_dt_machine_init(void)
 		exynos_sysram_init();
 
 	if (of_machine_is_compatible("samsung,exynos4210") ||
-			of_machine_is_compatible("samsung,exynos5250"))
+	    of_machine_is_compatible("samsung,exynos4212") ||
+	    of_machine_is_compatible("samsung,exynos4412") ||
+	    of_machine_is_compatible("samsung,exynos5250"))
 		platform_device_register(&exynos_cpuidle);
 
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-- 
1.8.2.3


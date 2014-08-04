Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaHDRq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:46:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36707 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaHDRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:46:22 -0400
X-AuditID: cbfee61b-f79f86d00000144c-64-53dfc6ecd984
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
Subject: [PATCH v4 5/5] ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12
 SoCs
Date: Mon, 04 Aug 2014 19:45:45 +0200
Message-id: <1407174345-31213-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd03x+4HG9xeqmGxccZ6Vot5n2Ut
	ehdcZbM42/SG3eL9oWfMFpseX2O1uLxrDpvF594jjBYzzu9jsjhz+hKrxck/vYwW62e8ZrHY
	+NXDgdfjzrU9bB6bl9R73P73mNljy9V2Fo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK2HTl
	BlPBU86KXV8eMTUwbuHoYuTkkBAwkTh+8yMbhC0mceHeeiCbi0NIYBGjxI/GjewQTheTxO4H
	3UwgVWwCVhIT21cxgtgiAmoSPYu3MoIUMQvsZZZY2r2JHSQhLBAq8W/RBhYQm0VAVeJt1xKw
	OK+Ah8Tic+9YIdYpSnQ/mwC2mlPAU+LHkV9gthBQTfeh5YwTGHkXMDKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAgOzGfSOxhXNVgcYhTgYFTi4RVQux8sxJpYVlyZe4hRgoNZSYS37gBQ
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2Oa0uYkMfml
	m5sPb2s7d57/yW2WK/e+1N/TfC66fKV4SIq2uK7Fd5//BwMWfog1KNu+KktL4WNc94xbTPsi
	ZigfPlfYxrLq+SfX4MVp+ha3Dff4sm1lzmNw9RCx+7qw2SLrUcpTlVYX/pzLh99MUUw62uZ4
	9+Yaz82LlrNM5Vmq4aUq8Ol0TK8SS3FGoqEWc1FxIgC97ETESAIAAA==
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaEJGie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25975 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaEJGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:25 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-89-536dc9605325
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 02/11] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Sat, 10 May 2014 15:56:29 +0900
Message-id: <1399704998-13321-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t8zI92Ek7nBBgtaBCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZdw7vJOpYC5PRev7Y6wNjEu4uhg5OCQETCQe9ph0
	MXICmWISF+6tZwOxhQSWMUrMnuQBETeRuLl/HnsXIxdQfDqjxIIZXSwQRW1MEg/m2IDYbAK6
	Ek/ez2UGsUUEsiWuNN5nBmlgFtjNKNHYOA9sqrBAqsTftVNZQRazCKhKTF2sChLmFfCQmLns
	PBvEPQoScyaBjeQU8JT4+nUxE8QqD4kH3UuZIe7ZxC6x96kOiM0iICDxbfIhFohWWYlNB6BK
	JCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkHCfsIPx3gHrQ4zJQOMm
	MkuJJucD4yWvJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhhz/yt8umTAcFrubrzo19aEX4KvTp6ZLb9o0f/p1y6k7r8t+Vnn1oYvlT1enJY6uzcv
	fV96MKL2pnLnHeVfD91v1u0QLOTRLhE5s7Jy9k4hoWkVUdZqzemPfO68LU55qf6EsdmoS6z+
	edi6Z87T8isc7pcx9ulfPn7qgkITO9vS6Qu/7T4YyOihxFKckWioxVxUnAgAc95KtY0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd2Ek7nBBpPOcFssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx7/BOpoK5
	PBWt74+xNjAu4epi5OSQEDCRuLl/HjuELSZx4d56ti5GLg4hgemMEgtmdLGAJIQE2pgkHsyx
	AbHZBHQlnryfywxiiwhkS1xpvM8M0sAssJtRorFxHhtIQlggVeLv2qmsXYwcHCwCqhJTF6uC
	hHkFPCRmLjvPBhKWEFCQmDMJbCSngKfE16+LmSBWeUg86F7KPIGRdwEjwypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4Jh6JrWDcWWDxSFGAQ5GJR7egrc5wUKsiWXFlbmHGCU4mJVEeFcc
	zA0W4k1JrKxKLcqPLyrNSS0+xJgMdNNEZinR5HxgvOeVxBsam5gZWRqZWRiZmJuTJqwkznug
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+P+Xxm1/jwvuF1kpc3zZk6SaQ/zfHbizaubPwoVdc7H
	2C+Jnv7waJmBy3PzjlBFxUe/C3VPSL3dvXd/Zuy6vQIz8z7wTeBY+kjqqN2Tz8dMrCP37rL6
	9Dtu65/4xzffF4tvCGGe9r2no25STpT+KXGnosyoK0svZcQ3mZ0Xb2Lu21dUcnalT44SS3FG
	oqEWc1FxIgAq4fee7QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As exynos_cpuidle_init and exynos_cpufreq_init function have just one lines
of code for registering platform devices. We can move these lines to
exynos_dt_machine_init and delete exynos_cpuidle_init and exynos_cpufreq_init
function. This will help in reducing lines of code in exynos.c, making it
more cleaner.

Suggested-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index bf8a473..288e414 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -176,19 +176,6 @@ static struct platform_device exynos_cpuidle = {
 	.id                = -1,
 };
 
-void __init exynos_cpuidle_init(void)
-{
-	if (soc_is_exynos5440())
-		return;
-
-	platform_device_register(&exynos_cpuidle);
-}
-
-void __init exynos_cpufreq_init(void)
-{
-	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-}
-
 static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
@@ -303,8 +290,10 @@ static void __init exynos_dt_machine_init(void)
 		}
 	}
 
-	exynos_cpuidle_init();
-	exynos_cpufreq_init();
+	if (!soc_is_exynos5440())
+		platform_device_register(&exynos_cpuidle);
+
+	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.7.10.4


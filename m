Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaFYMtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:49:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50111 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaFYMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:49:06 -0400
X-AuditID: cbfee68f-b7fef6d000003970-63-53aac54160f1
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 2/6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Wed, 25 Jun 2014 18:15:38 +0530
Message-id: <1403700342-9678-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSq+t4dFWwwYMXHBbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxsvMcc8Fpnoq/O3ewNjCe5epi5OSQEDCR
	mPbhNBuELSZx4d56IJuLQ0hgKaPE1FezWGCK3vxqZIdITGeUePjjASOEM4FJomfyJLB2NgFd
	iSfv5zKD2CIC2RL9t1ezgBQxC5xilJi9eRo7SEJYIFnizoI9TF2MHBwsAqoSDZdjQcK8Au4S
	P15cZQMJSwgoSMyZZAMS5hTwkHi06AbYEUJAJR0Nf8GOkBDYxi7x7c0sJpAEi4CAxLfJh1gg
	emUlNh1ghjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjIDT/571
	72C8e8D6EGMy0LiJzFKiyfnACMoriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYwWE5xrl4ltnT679m7wseDGv8YpF3buNwyutt158sr1ZUzZk4SV
	bjU8F/4jbdxh3n5JyWjd4Un7/+xxihGeLGz5NFx7nZ9aRk77pYMbr3KqWvjNWsZ2kXnFaw+m
	32uemcSV2Qeabjfclz7jmJ90gYml/zMJqaUyk1pFXJYV5hpOSBJ6t/0vm6ESS3FGoqEWc1Fx
	IgBLCuvclgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQV3Ho6uCDXa/YLRYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGS87
	zzEXnOap+LtzB2sD41muLkZODgkBE4k3vxrZIWwxiQv31rN1MXJxCAlMZ5R4+OMBI4QzgUmi
	Z/IkNpAqNgFdiSfv5zKD2CIC2RL9t1ezgBQxC5xilJi9eRrYKGGBZIk7C/YwdTFycLAIqEo0
	XI4FCfMKuEv8eHGVDSQsIaAgMWeSDUiYU8BD4tGiGywgthBQSUfDX/YJjLwLGBlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgTH1zOpHYwrGywOMQpwMCrx8F6YvTJYiDWxrLgy9xCjBAez
	kgiv+/5VwUK8KYmVValF+fFFpTmpxYcYTYFumsgsJZqcD4z9vJJ4Q2MTc1NjU0sTCxMzSyVx
	3gOt1oFCAumJJanZqakFqUUwfUwcnFINjOFV4WosP6o3dy37pHpnyVm7VZ9sbv1stIyqYW8v
	YH9dq3AjZi1TIleQu9SRh8dq/hmb8NYUJ+5ZtW9WB/OWAy8covd2nlPdM2dTnPD1f6ovD08/
	fPGnjOGOz0//HfHQ/7q/ceKrzsIdeZfyZh9uXBTwkDv6ycPXC+vPVq049v+Oxgbbj9eXWRgr
	sRRnJBpqMRcVJwIAn9i61cUCAAA=
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/exynos.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 6affcd9..e54d885 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -171,19 +171,6 @@ static struct platform_device exynos_cpuidle = {
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
@@ -271,8 +258,10 @@ static void __init exynos_dt_machine_init(void)
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
1.7.9.5


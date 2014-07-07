Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaGGDxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13478 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaGGDxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:39 -0400
X-AuditID: cbfee68f-b7fef6d000003970-2b-53ba19c1bf5c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 2/6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Mon, 07 Jul 2014 09:20:52 +0530
Message-id: <1404705056-11965-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSo3tQclewwYPnshbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxcPJmtoLXvBU7Jx5ga2B8yN3FyMkhIWAi
	MaXjLTOELSZx4d56ti5GLg4hgaWMEitOz2GCKXq5cTM7RGI6o8Tus/dZIZwJTBJPei+xgFSx
	CehKPHk/F2yUiEC2RP/t1SwgRcwCpxglZm+exg6SEBZIlni1bT+YzSKgKjHx81E2EJtXwEPi
	17uXQHEOoHUKEnMm2YCEOQU8JZZ8mAQ2Uwio5O65Q4wgMyUE1rFLnFp3gAlijoDEt8mHWCB6
	ZSU2HYB6R1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIyB0/+e9e9g
	vHvA+hBjMtC4icxSosn5wBjKK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2M29ZWFUg71DmsrOaMlnT5UMUmnWdds1upSv1w1/m6vJUJGxN/rSwx
	KM5xTHee7cOtcUQhKX3F/9CCZXMKhduNP7tfnfAuvUHVv0pKLzzWJOC/VgoXy7pdTpLP3nJr
	JSgLOijeCHC5rph6/qzg1GUli083bS68HsVyLHryKa+DjovEPdaqOCqxFGckGmoxFxUnAgDC
	NCJXlwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd2DkruCDZo+iVosm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsXi5rPtTA7cHi3NPWwe
	m5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QUUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjIOT
	N7MVvOat2DnxAFsD40PuLkZODgkBE4mXGzezQ9hiEhfurWfrYuTiEBKYziix++x9VghnApPE
	k95LLCBVbAK6Ek/ez2UGsUUEsiX6b69mASliFjjFKDF78zSwUcICyRKvtu0Hs1kEVCUmfj7K
	BmLzCnhI/Hr3EijOAbROQWLOJBuQMKeAp8SSD5PAZgoBldw9d4hxAiPvAkaGVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBEfZMagfjygaLQ4wCHIxKPLwHVu0MFmJNLCuuzD3EKMHBrCTC
	e8YNKMSbklhZlVqUH19UmpNafIjRFOioicxSosn5wOjPK4k3NDYxNzU2tTSxMDGzVBLnPdBq
	HSgkkJ5YkpqdmlqQWgTTx8TBKdXAaOj/iaf97YYHTcm+z+V3mr/7uk7eYOPtwCzbZPFcTf6a
	JZVzLj9y75gT8cY1uSTr8fTKL3YninalZarYvZJfnu8Z7vk2Ti0q8vPU6PfKTX5zHr37dHjS
	NuWYUMbf1z4fuCwRdZJR4uSZtt8/nhwQ7vq195JEblva/Znqlg6z55lEn8u8d6xxvxJLcUai
	oRZzUXEiAElY1iXGAgAA
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
 arch/arm/mach-exynos/exynos.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index ff60b4c..47170eb 100644
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
 void __iomem *sysram_base_addr;
 void __iomem *sysram_ns_base_addr;
 
@@ -300,10 +287,11 @@ static void __init exynos_dt_machine_init(void)
 	if (!IS_ENABLED(CONFIG_SMP))
 		exynos_sysram_init();
 
-	if (!of_machine_is_compatible("samsung,exynos5420"))
-		exynos_cpuidle_init();
+	if (!of_machine_is_compatible("samsung,exynos5420") ||
+			!of_machine_is_compatible("samsung,exynos5440"))
+		platform_device_register(&exynos_cpuidle);
 
-	exynos_cpufreq_init();
+	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.7.9.5


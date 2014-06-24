Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaFXN6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:58:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10124 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaFXN5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:50 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c1-53a983dae00c
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on Exynos4210
 and 5250
Date: Tue, 24 Jun 2014 15:57:15 +0200
Message-id: <1403618235-19353-7-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t/xq7q3mlcGG9zeZWLRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDJebPzJWrCbo+LQ490sDYzd7F2MHBwSAiYSO55YdzFyApliEhfurWfrYuTi
	EBJYyijRM+MKM0hCSKCPSeJwawGIzSagJvG54REbiC0ioCrxuW0BO4jNLPCEUWLWUzeQmcIC
	4RIbOktBwixAJfuuTQAr5xVwkphwfzMrxC45id5tb8DGcwo4S+xs38YKscpJ4v/JJqYJjLwL
	GBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE0dcdjEuPWR1iFOBgVOLhrdixIliINbGs
	uDL3EKMEB7OSCO+NmpXBQrwpiZVVqUX58UWlOanFhxiZODilGhiNhY5p2gUzhHzPu3hk30Hn
	tElsSv+ufLedGCue/XJ6zXOG0Kjv1/zXbihlD9W+47Eq6dOLnRP77ya9fLzubNSmKw5tB3xE
	dgsFn5nq6cN35VbZs51rlwq98O/1kijydUxVcExMXvkh0MM5tKp879W/LZJ3Az0jFc72nOzX
	0mY8PtGq70pk9C0lluKMREMt5qLiRAD/afeKAAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the Exynos cpuidle driver works correctly only on Exynos4210
and 5250. Trying to use it with just one CPU online on any other Exynos
SoC will lead to system failure, due to unsupported AFTR mode on other
SoCs. This patch fixes the problem by registering the driver only on
supported SoCs and letting others simply use default WFI mode until
support for them is added.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index f38cf7c..176bbf5 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -173,10 +173,8 @@ static struct platform_device exynos_cpuidle = {
 
 void __init exynos_cpuidle_init(void)
 {
-	if (soc_is_exynos5440())
-		return;
-
-	platform_device_register(&exynos_cpuidle);
+	if (soc_is_exynos4210() || soc_is_exynos5250())
+		platform_device_register(&exynos_cpuidle);
 }
 
 void __init exynos_cpufreq_init(void)
-- 
1.9.3


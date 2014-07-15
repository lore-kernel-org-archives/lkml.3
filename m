Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbaGORMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36392 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 63/94] ARM: EXYNOS: Register cpuidle device only on exynos4210 and 5250
Date: Tue, 15 Jul 2014 20:01:18 +0300
Message-Id: <1405443709-15288-63-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Currently, the exynos cpuidle driver works correctly only on exynos4210
and 5250. Trying to use it with just one CPU online on any other exynos
SoCs will lead to system failure, due to unsupported AFTR mode on other
SoCs. This patch fixes the problem by registering the driver only on
supported SoCs and letting others simply use default WFI mode until
support for them is added.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-exynos/exynos.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 95cad25..46d893f 100644
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
1.7.10.4


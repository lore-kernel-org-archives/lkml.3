Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaGOROS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46841 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaGORCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:14 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 50/94] ARM: EXYNOS: Update secondary boot addr for secure mode
Date: Tue, 15 Jul 2014 20:01:05 +0300
Message-Id: <1405443709-15288-50-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

Almost all Exynos-series of SoCs that run in secure mode don't need
additional offset for every CPU, with Exynos4412 being the only
exception.

Tested on Origen-Quad (Exynos4412) and Arndale-Octa (Exynos5420).

While at it, fix the coding style (space around *).

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Tested-by: Andreas Faerber <afaerber@suse.de>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-exynos/firmware.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index eb91d23..e8797bb 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -57,8 +57,13 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 
 	boot_reg = sysram_ns_base_addr + 0x1c;
 
-	if (!soc_is_exynos4212() && !soc_is_exynos3250())
-		boot_reg += 4*cpu;
+	/*
+	 * Almost all Exynos-series of SoCs that run in secure mode don't need
+	 * additional offset for every CPU, with Exynos4412 being the only
+	 * exception.
+	 */
+	if (soc_is_exynos4412())
+		boot_reg += 4 * cpu;
 
 	__raw_writel(boot_addr, boot_reg);
 	return 0;
-- 
1.7.10.4


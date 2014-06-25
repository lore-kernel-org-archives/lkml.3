Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaFYLoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:44:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11222 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaFYLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:44:32 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-89-53aab61e5ba2
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Daniel Drake <drake@endlessm.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
Date: Wed, 25 Jun 2014 13:43:54 +0200
Message-id: <1403696634-12779-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xK7py21YFG/z+bGbxaP5jZoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVmsPXKX3WL9jNcsFqt2/WF04PBY9D3LY+esu+wem5fUe/RtWcXo
	8XmTXABrFJdNSmpOZllqkb5dAlfGieMPmArWcFe837iOvYHxGGcXIweHhICJxKVVCV2MnECm
	mMSFe+vZuhi5OIQEljJKdHw+CeX0MUlM7FrNAlLFJqAm8bnhERuILSKgKvG5bQE7SBGzQCeT
	xOG1m8CKhAV8JNoefAIrYgEq+n99FTuIzSvgJNF/8j8bxDo5id5tb5hBbE4BZ4nefY8ZQWwh
	oJqbe86wT2DkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJLi+7GBcfMzqEKMAB6MS
	D28Az6pgIdbEsuLK3EOMEhzMSiK89RuAQrwpiZVVqUX58UWlOanFhxiZODilGhiDfrhkT18Y
	XRm49qlackiJV3e08Opf/8uW77oVtnB/YpBryK4EDcMn7zpZm0JvP+o7yFHStO5bpf/rhWHR
	xp0aLvdFuXt5vn5d63rkyaaGsA0X5md1/DbgbtX6tM8zZvJ3qUfMak+nHLR/o5ThK7phyqP/
	h6K2MvyW3/T1DrfnxK7u89VKC1YosRRnJBpqMRcVJwIAsYB8iQwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recently merged patches and previous merge conflicts, the Samsung
PM Debug functionality no longer can be enabled. This patch fixes
incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
missing header inclusion.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/plat-samsung/Kconfig    | 5 +++--
 arch/arm/plat-samsung/pm-debug.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 301b892..ad9515f 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -413,8 +413,9 @@ config S5P_DEV_MFC
 comment "Power management"
 
 config SAMSUNG_PM_DEBUG
-	bool "S3C2410 PM Suspend debug"
-	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
+	bool "Samsung PM Suspend debug"
+	depends on PM && DEBUG_KERNEL
+	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
diff --git a/arch/arm/plat-samsung/pm-debug.c b/arch/arm/plat-samsung/pm-debug.c
index 8f19f66..3960960 100644
--- a/arch/arm/plat-samsung/pm-debug.c
+++ b/arch/arm/plat-samsung/pm-debug.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/serial_core.h>
+#include <linux/serial_s3c.h>
 #include <linux/io.h>
 
 #include <asm/mach/map.h>
-- 
1.9.3


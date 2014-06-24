Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaFXN6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:58:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27654 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaFXN5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:50 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-bc-53a983da57b7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
Date: Tue, 24 Jun 2014 15:57:13 +0200
Message-id: <1403618235-19353-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xq7q3mlcGG/x6xmbRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDK+HN3FVtDFW7Hp6XX2BsZ3XF2MnBwSAiYSG7s62CFsMYkL99azdTFycQgJ
	LGWUaGx/ygqSEBLoY5I43FoAYrMJqEl8bnjEBmKLCKhKfG5bANbMLPCEUWLWUzcQW1jAU+Ly
	389gNSxANRPmNzKC2LwCThK7/1xhglgmJ9G77Q0ziM0p4Cyxs30b1C4nif8nm5gmMPIuYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESSF93MC49ZnWIUYCDUYmHt2LHimAh1sSy4src
	Q4wSHMxKIrw3alYGC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBMymN4N/v+pANxPR+sC/PfLMx+
	4KdULXa85vj0/D0PQtpEDot7uRbNKDT9kujL4qXMk+u76d1E9kqW98mZuVa3NRd5d6l94mjm
	rp3O9L+QtfXzmuu/pt2p/Vo+/atZ57f06N08zfMjyj7sE8zY1rgvM0c/gdHQYY7iNmWdc1fM
	xXs0Ar4KxSuxFGckGmoxFxUnAgArIinJAgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recently merged patches and previous merge conflicts, the Samsung
PM Debug functionality no longer can be enabled. This patch fixes
incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
missing header inclusion.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/plat-samsung/Kconfig    | 8 +++++++-
 arch/arm/plat-samsung/pm-debug.c | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 301b892..483c959 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -412,9 +412,14 @@ config S5P_DEV_MFC
 
 comment "Power management"
 
+config HAVE_SAMSUNG_PM_DEBUG
+	bool
+	help
+	  Allow compilation of Samsung PM debugging code.
+
 config SAMSUNG_PM_DEBUG
 	bool "S3C2410 PM Suspend debug"
-	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
+	depends on PM && DEBUG_KERNEL && HAVE_SAMSUNG_PM_DEBUG
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
@@ -484,6 +489,7 @@ config S5P_SLEEP
 
 config DEBUG_S3C_UART
 	depends on PLAT_SAMSUNG
+	select HAVE_SAMSUNG_PM_DEBUG
 	int
 	default "0" if DEBUG_S3C_UART0
 	default "1" if DEBUG_S3C_UART1
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


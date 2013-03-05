Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3CESvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:51:11 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55568 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370Ab3CESvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:51:09 -0500
Message-ID: <1362509466.16460.108.camel@x61.thuisdomein>
Subject: [PATCH] ARM: EXYNOS: remove EXYNOS_DEV_SYSMMU entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: KyongHo Cho <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 19:51:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 18:51:07.0054 (UTC) FILETIME=[651CDCE0:01CE19D2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 25e9d28d927d2e1731df53f60cde53d75bcb7c36 ("ARM: EXYNOS: remove
system mmu initialization from exynos tree") removed the Kconfig symbol
EXYNOS_DEV_SYSMMU. Remove its last traces too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Please note that this patch changes the dependencies of EXYNOS_IOMMU
(it removed a dependency that could never be met). That's probably what
needs to be done but some specific review is needed here.

 arch/arm/mach-exynos/Kconfig | 4 ----
 drivers/iommu/Kconfig        | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 70f94c8..6c2bdc3 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -200,7 +200,6 @@ config MACH_SMDKV310
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
 	select EXYNOS_DEV_DRM
-	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC1
@@ -254,7 +253,6 @@ config MACH_UNIVERSAL_C210
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
 	select EXYNOS_DEV_DRM
-	select EXYNOS_DEV_SYSMMU
 	select HAVE_SCHED_CLOCK
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC2
@@ -331,7 +329,6 @@ config MACH_ORIGEN
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
 	select EXYNOS_DEV_DRM
-	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC2
@@ -367,7 +364,6 @@ config MACH_SMDK4212
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
 	select EXYNOS_DEV_DRM
-	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_HSMMC3
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5c514d07..c520c20 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -168,7 +168,7 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
+	depends on ARCH_EXYNOS
 	select IOMMU_API
 	help
 	  Support for the IOMMU(System MMU) of Samsung Exynos application
-- 
1.7.11.7


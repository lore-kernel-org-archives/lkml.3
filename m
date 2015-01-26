Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbbAZXui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:50:38 -0500
Received: from 8bytes.org ([81.169.241.247]:50696 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbbAZXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:50:34 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 1/4] iommu: Make more drivers depend on COMPILE_TEST
Date: Tue, 27 Jan 2015 00:50:27 +0100
Message-Id: <1422316230-18893-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316230-18893-1-git-send-email-joro@8bytes.org>
References: <1422316230-18893-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

For easier compile testing of these iommu drivers.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/Kconfig | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 325188e..dfa6cf1 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -19,7 +19,8 @@ config OF_IOMMU
 
 config FSL_PAMU
 	bool "Freescale IOMMU support"
-	depends on PPC_E500MC
+	depends on PPC32
+	depends on PPC_E500MC || COMPILE_TEST
 	select IOMMU_API
 	select GENERIC_ALLOCATOR
 	help
@@ -30,7 +31,8 @@ config FSL_PAMU
 # MSM IOMMU support
 config MSM_IOMMU
 	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	depends on ARM
+	depends on ARCH_MSM8X60 || ARCH_MSM8960 || COMPILE_TEST
 	select IOMMU_API
 	help
 	  Support for the IOMMUs found on certain Qualcomm SOCs.
@@ -140,7 +142,8 @@ config IRQ_REMAP
 # OMAP IOMMU support
 config OMAP_IOMMU
 	bool "OMAP IOMMU Support"
-	depends on ARCH_OMAP2PLUS
+	depends on ARM
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select IOMMU_API
 
 config OMAP_IOMMU_DEBUG
-- 
1.9.1


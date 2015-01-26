Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbbAZXvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:51:07 -0500
Received: from 8bytes.org ([81.169.241.247]:50701 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbbAZXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:50:34 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 2/4] iommu/exynos: Make driver depend on REGULATOR
Date: Tue, 27 Jan 2015 00:50:28 +0100
Message-Id: <1422316230-18893-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316230-18893-1-git-send-email-joro@8bytes.org>
References: <1422316230-18893-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When regulator is not selected during kconfig, linking of
the exynos iommu driver fails due to missing symbols.
Fix it!

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index dfa6cf1..2e6100d 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -190,7 +190,7 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && ARM
+	depends on ARCH_EXYNOS && ARM && REGULATOR
 	select IOMMU_API
 	select ARM_DMA_USE_IOMMU
 	help
-- 
1.9.1


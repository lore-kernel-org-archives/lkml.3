Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3BFSez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:34:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5176 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3BFSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:34:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Feb 2013 10:31:39 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on TEGRA_IOMMU_SMMU
Date: Wed, 6 Feb 2013 20:34:26 +0200
Message-ID: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New SoC, Tegra114 also uses SMMU. Change tegra_ahb_enable_smmu()'s
dependency from ARCH_TEGRA_3x_SOC to TEGRA_IOMMU_SMMU. No need to edit
whenever a new Tegra SoC comes.

The following combination caused build error, which this patch fixes.

CONFIG_ARCH_TEGRA_2x_SOC=y
\# CONFIG_ARCH_TEGRA_3x_SOC is not set
CONFIG_ARCH_TEGRA_114_SOC=y

drivers/iommu/tegra-smmu.c:485: undefined reference to 'tegra_ahb_enable_smmu'

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/amba/tegra-ahb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index ab92785..093c435 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -130,7 +130,7 @@ static inline void gizmo_writel(struct tegra_ahb *ahb, u32 value, u32 offset)
 	writel(value, ahb->regs + offset);
 }
 
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+#ifdef CONFIG_TEGRA_IOMMU_SMMU
 static int tegra_ahb_match_by_smmu(struct device *dev, void *data)
 {
 	struct tegra_ahb *ahb = dev_get_drvdata(dev);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3BDMck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:32:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11695 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3BDMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:32:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Feb 2013 04:32:37 -0800
From: Sami Liedes <sliedes@nvidia.com>
To: <iommu@lists.linux-foundation.org>
CC: Sami Liedes <sliedes@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] iommu/tegra: Add missing spinlock initialization
Date: Mon, 4 Feb 2013 14:31:48 +0200
Message-ID: <1359981110-9924-1-git-send-email-sliedes@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix tegra_smmu_probe() to initialize client_lock spinlocks in
per-address-space structures.

Signed-off-by: Sami Liedes <sliedes@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index f08dbcd..46cc8cf 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1,7 +1,7 @@
 /*
  * IOMMU API for SMMU in Tegra30
  *
- * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2011-2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -1217,6 +1217,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		as->pte_attr = _PTE_ATTR;
 
 		spin_lock_init(&as->lock);
+		spin_lock_init(&as->client_lock);
 		INIT_LIST_HEAD(&as->client);
 	}
 	spin_lock_init(&smmu->lock);
-- 
1.7.9.5


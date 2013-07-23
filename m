Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab3GWSCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:02:54 -0400
Received: from sauhun.de ([89.238.76.85]:58719 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933905Ab3GWSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:52 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org
Subject: [PATCH 08/27] drivers/iommu: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:41 +0200
Message-Id: <1374602524-3398-9-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/iommu/tegra-smmu.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index f6f120e..e066560 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1177,8 +1177,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			return -ENODEV;
 		smmu->regs[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(smmu->regs[i]))
 			return PTR_ERR(smmu->regs[i]);
-- 
1.7.10.4


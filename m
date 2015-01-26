Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbbAZXvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:51:03 -0500
Received: from 8bytes.org ([81.169.241.247]:50718 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbbAZXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:50:34 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 4/4] iommu/fsl: Use %pa to print phys_addr_t
Date: Tue, 27 Jan 2015 00:50:30 +0100
Message-Id: <1422316230-18893-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316230-18893-1-git-send-email-joro@8bytes.org>
References: <1422316230-18893-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Fix two compile warnings.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/fsl_pamu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index 80ac68d..e63904b 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -352,7 +352,7 @@ int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
 	unsigned long fspi;
 
 	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
-		pr_debug("window size too small or not a power of two %llx\n", win_size);
+		pr_debug("window size too small or not a power of two %pa\n", &win_size);
 		return -EINVAL;
 	}
 
@@ -1138,7 +1138,7 @@ static int __init fsl_pamu_probe(struct platform_device *pdev)
 
 	if (csd_port_id) {
 		dev_dbg(&pdev->dev, "creating coherency subdomain at address "
-			"0x%llx, size %zu, port id 0x%08x", ppaact_phys,
+			"%pa, size %zu, port id 0x%08x", &ppaact_phys,
 			mem_size, csd_port_id);
 
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
-- 
1.9.1


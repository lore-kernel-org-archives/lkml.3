Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbaHZPMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:12:46 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40376 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaHZPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:11:49 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] PCI: tegra: Fix extended configuration space mapping
Date: Tue, 26 Aug 2014 17:11:36 +0200
Message-Id: <1409065898-26887-5-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
References: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Daifuku <pdaifuku@nvidia.com>

The 16 chunks of 64 KiB that need to be stitched together to make up the
configuration space for one bus (1 MiB) are located 24 bits (== 16 MiB)
apart in physical address space. This is determined by the start of the
extended register field (bits 24-27) in the physical mapping.

Signed-off-by: Peter Daifuku <pdaifuku@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index bd53b123218b..8264bce77750 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -383,7 +383,7 @@ static struct tegra_pcie_bus *tegra_pcie_bus_alloc(struct tegra_pcie *pcie,
 	for (i = 0; i < 16; i++) {
 		unsigned long virt = (unsigned long)bus->area->addr +
 				     i * SZ_64K;
-		phys_addr_t phys = cs + i * SZ_1M + busnr * SZ_64K;
+		phys_addr_t phys = cs + i * SZ_16M + busnr * SZ_64K;
 
 		err = ioremap_page_range(virt, virt + SZ_64K, phys, prot);
 		if (err < 0) {
-- 
2.0.4


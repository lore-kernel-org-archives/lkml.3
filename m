Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966304AbaFQVs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966283AbaFQVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 112/212] iommu/amd: Fix interrupt remapping for aliased devices
Date: Tue, 17 Jun 2014 14:43:26 -0700
Message-Id: <1403041506-13646-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit e028a9e6b8a637af09ac4114083280df4a7045f1 upstream.

An apparent cut and paste error prevents the correct flags from being
set on the alias device resulting in MSI on conventional PCI devices
failing to work.  This also produces error events from the IOMMU like:

AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:14.4 address=0x000000fdf8000000 flags=0x0a00]

Where 14.4 is a PCIe-to-PCI bridge with a device behind it trying to
use MSI interrupts.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/amd_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 72531f0..76e579a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3999,7 +3999,7 @@ static struct irq_remap_table *get_irq_table(u16 devid, bool ioapic)
 	iommu_flush_dte(iommu, devid);
 	if (devid != alias) {
 		irq_lookup_table[alias] = table;
-		set_dte_irq_entry(devid, table);
+		set_dte_irq_entry(alias, table);
 		iommu_flush_dte(iommu, alias);
 	}
 
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaFCMEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:04:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbaFCLli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 071/138] iommu/amd: Fix interrupt remapping for aliased devices
Date: Tue,  3 Jun 2014 12:38:37 +0100
Message-Id: <1401795584-22664-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/amd_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6dc659426a51..b89025108ba8 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3997,7 +3997,7 @@ static struct irq_remap_table *get_irq_table(u16 devid, bool ioapic)
 	iommu_flush_dte(iommu, devid);
 	if (devid != alias) {
 		irq_lookup_table[alias] = table;
-		set_dte_irq_entry(devid, table);
+		set_dte_irq_entry(alias, table);
 		iommu_flush_dte(iommu, alias);
 	}
 
-- 
1.9.1


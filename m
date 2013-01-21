Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3AUSrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:47:03 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62961 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3AUSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:47:00 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
Date: Mon, 21 Jan 2013 19:48:59 +0100
Message-Id: <1358794139-4820-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have the quirk entry for the mobile platform, but also
reports on some desktop versions. So be paranoid and set it
everywhere.

References: http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33138.html
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-and-tested-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/iommu/intel-iommu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9743769..19854bf 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4215,13 +4215,19 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
 {
 	/*
 	 * Mobile 4 Series Chipset neglects to set RWBF capability,
-	 * but needs it:
+	 * but needs it. Same seems to hold for the desktop versions.
 	 */
 	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
 	rwbf_quirk = 1;
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e10, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e20, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e30, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e40, quirk_iommu_rwbf);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e90, quirk_iommu_rwbf);
 
 #define GGC 0x52
 #define GGC_MEMORY_SIZE_MASK	(0xf << 8)
-- 
1.7.10.4


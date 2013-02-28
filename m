Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3B1Oue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab3B1OuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Woodhouse <dwmw2@infradead.org>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 110/139] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
Date: Thu, 28 Feb 2013 14:44:20 +0000
Message-Id: <1362062689-2567-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 210561ffd72d00eccf12c0131b8024d5436bae95 upstream.

We already have the quirk entry for the mobile platform, but also
reports on some desktop versions. So be paranoid and set it
everywhere.

References: http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33138.html
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Reported-and-tested-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/intel-iommu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1f78d86..eafc4ed 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4210,13 +4210,19 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
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
1.8.1.2


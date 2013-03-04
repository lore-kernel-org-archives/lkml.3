Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3CDECu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:02:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32898 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463Ab3CDDnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:45 -0500
Message-Id: <20130304033715.763611702@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Woodhouse <dwmw2@infradead.org>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Subject: [ 083/153] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4140,13 +4140,19 @@ static void __devinit quirk_iommu_rwbf(s
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab3B0AQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:16:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3B0AJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 52/86] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
Date: Tue, 26 Feb 2013 16:08:00 -0800
Message-Id: <20130226235918.309346473@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 210561ffd72d00eccf12c0131b8024d5436bae95 upstream.

We already have the quirk entry for the mobile platform, but also
reports on some desktop versions. So be paranoid and set it
everywhere.

References: http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33138.html
Reported-and-tested-by: Mihai Moldovan <ionic@ionic.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4212,13 +4212,19 @@ static void __devinit quirk_iommu_rwbf(s
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



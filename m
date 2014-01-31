Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaAaPQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaAaPHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:31 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 15/34] igbvf: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:34 +0100
Message-Id: <3de48ccd00189524a07c6d38f0533caa3e5d4293.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 675435f..e2c6d80 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1043,11 +1043,11 @@ static void igbvf_set_interrupt_capability(struct igbvf_adapter *adapter)
 		for (i = 0; i < 3; i++)
 			adapter->msix_entries[i].entry = i;
 
-		err = pci_enable_msix(adapter->pdev,
-		                      adapter->msix_entries, 3);
+		err = pci_enable_msix_range(adapter->pdev,
+		                            adapter->msix_entries, 3, 3);
 	}
 
-	if (err) {
+	if (err < 0) {
 		/* MSI-X failed */
 		dev_err(&adapter->pdev->dev,
 		        "Failed to initialize MSI-X interrupts.\n");
-- 
1.7.7.6


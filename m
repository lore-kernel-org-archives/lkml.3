Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaAaPQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:16:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbaAaPHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:32 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 12/34] e1000e: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:31 +0100
Message-Id: <0ec36309e17031a66d3a6ab489fc60702b6d76b3.1391172839.git.agordeev@redhat.com>
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
 drivers/net/ethernet/intel/e1000e/netdev.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6d91933..7735d1a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2041,10 +2041,11 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 				for (i = 0; i < adapter->num_vectors; i++)
 					adapter->msix_entries[i].entry = i;
 
-				err = pci_enable_msix(adapter->pdev,
-						      adapter->msix_entries,
-						      adapter->num_vectors);
-				if (err == 0)
+				err = pci_enable_msix_range(adapter->pdev,
+							adapter->msix_entries,
+							adapter->num_vectors,
+							adapter->num_vectors);
+				if (err > 0)
 					return;
 			}
 			/* MSI-X failed, so fall through and try MSI */
-- 
1.7.7.6


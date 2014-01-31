Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaAaPHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbaAaPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:30 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 14/34] igb: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:33 +0100
Message-Id: <af7e2d8611ac6590fad19ea6c0061017558bff2e.1391172839.git.agordeev@redhat.com>
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
 drivers/net/ethernet/intel/igb/igb_main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 46d31a4..84dfa3f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1111,10 +1111,11 @@ static void igb_set_interrupt_capability(struct igb_adapter *adapter, bool msix)
 	for (i = 0; i < numvecs; i++)
 		adapter->msix_entries[i].entry = i;
 
-	err = pci_enable_msix(adapter->pdev,
-			      adapter->msix_entries,
-			      numvecs);
-	if (err == 0)
+	err = pci_enable_msix_range(adapter->pdev,
+				    adapter->msix_entries,
+				    numvecs,
+				    numvecs);
+	if (err > 0)
 		return;
 
 	igb_reset_interrupt_capability(adapter);
-- 
1.7.7.6


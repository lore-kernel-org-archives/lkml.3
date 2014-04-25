Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaDYIFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbaDYIFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:05:16 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Dept-HSGLinuxNICDev@qlogic.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Fri, 25 Apr 2014 10:06:25 +0200
Message-Id: <0a0d5f5c33d86e3777c22c3c1bbd81035660d57c.1398412015.git.agordeev@redhat.com>
In-Reply-To: <cover.1398412015.git.agordeev@redhat.com>
References: <cover.1398412015.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Dept-HSGLinuxNICDev@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index dbf7539..26f022b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -690,8 +690,8 @@ int qlcnic_setup_tss_rss_intr(struct qlcnic_adapter *adapter)
 		adapter->msix_entries[vector].entry = vector;
 
 restore:
-	err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
-	if (err > 0) {
+	err = pci_enable_msix_exact(pdev, adapter->msix_entries, num_msix);
+	if (err == -ENOSPC) {
 		if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
 			return -ENOSPC;
 
-- 
1.7.7.6


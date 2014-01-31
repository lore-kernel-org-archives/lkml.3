Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaAaPHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaAaPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:47 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 26/34] netxen: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:45 +0100
Message-Id: <af9ae216bb0f0453ceca1a5986be9a1a5cee93f4.1391172839.git.agordeev@redhat.com>
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
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 70849de..f09c35d 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -643,8 +643,9 @@ static int netxen_setup_msi_interrupts(struct netxen_adapter *adapter,
 
 	if (adapter->msix_supported) {
 		netxen_init_msix_entries(adapter, num_msix);
-		err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
-		if (err == 0) {
+		err = pci_enable_msix_range(pdev, adapter->msix_entries,
+					    num_msix, num_msix);
+		if (err > 0) {
 			adapter->flags |= NETXEN_NIC_MSIX_ENABLED;
 			netxen_set_msix_bit(pdev, 1);
 
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab3CMX2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904Ab3CMX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v3 10/27] PCI, pciehp: Use for_each_pci_resource() helper
Date: Wed, 13 Mar 2013 16:28:05 -0700
Message-Id: <1363217302-14383-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/pciehp_hpc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 5127f3f..2df1ae3 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -807,6 +807,7 @@ static inline void dbg_ctrl(struct controller *ctrl)
 	int i;
 	u16 reg16;
 	struct pci_dev *pdev = ctrl->pcie->port;
+	struct resource *res;
 
 	if (!pciehp_debug)
 		return;
@@ -822,11 +823,11 @@ static inline void dbg_ctrl(struct controller *ctrl)
 		  pdev->subsystem_vendor);
 	ctrl_info(ctrl, "  PCIe Cap offset      : 0x%02x\n",
 		  pci_pcie_cap(pdev));
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+	for_each_pci_resource(pdev, res, i, PCI_ALL_RES) {
 		if (!pci_resource_len(pdev, i))
 			continue;
 		ctrl_info(ctrl, "  PCI resource [%d]     : %pR\n",
-			  i, &pdev->resource[i]);
+			  i, res);
 	}
 	ctrl_info(ctrl, "Slot Capabilities      : 0x%08x\n", ctrl->slot_cap);
 	ctrl_info(ctrl, "  Physical Slot Number : %d\n", PSN(ctrl));
-- 
1.7.10.4


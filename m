Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3IKE5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3IKE4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:51 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eixHX7o2HFQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6RvMgk8FxMsA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042930.860886823@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [232/251] iwlwifi: pcie: disable L1 Active after pci_enable_device
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0232-iwlwifi-pcie-disable-L1-Active-after-pci_enable_devi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit eabc4ac5d7606a57ee2b7308cb7323ea8f60183b ]

As Arjan pointed out, we mustn't do anything related to PCI
configuration until the device is properly enabled with
pci_enable_device().

Cc: stable@vger.kernel.org
Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dbeebef..d7eeb96 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2100,16 +2100,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->irq_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	/* W/A - seems to solve weird behavior. We need to remove this if we
-	 * don't want to stay in L1 all the time. This wastes a lot of power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-			       PCIE_LINK_STATE_CLKPM);
-
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_no_pci;
 	}
 
+	/* W/A - seems to solve weird behavior. We need to remove this if we
+	 * don't want to stay in L1 all the time. This wastes a lot of power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-- 
1.7.10.4



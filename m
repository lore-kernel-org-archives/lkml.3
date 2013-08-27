Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3H0BHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3H0BHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 62/74] iwlwifi: pcie: disable L1 Active after pci_enable_device
Date: Mon, 26 Aug 2013 18:09:00 -0700
Message-Id: <20130827010437.197499073@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit eabc4ac5d7606a57ee2b7308cb7323ea8f60183b upstream.

As Arjan pointed out, we mustn't do anything related to PCI
configuration until the device is properly enabled with
pci_enable_device().

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1481,16 +1481,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 	spin_lock_init(&trans_pcie->reg_lock);
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



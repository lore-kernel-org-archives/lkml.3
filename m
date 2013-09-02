Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab3IBIz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab3IBIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 34/58] iwlwifi: pcie: disable L1 Active after pci_enable_device
Date: Mon,  2 Sep 2013 09:54:19 +0100
Message-Id: <1378112083-9475-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit eabc4ac5d7606a57ee2b7308cb7323ea8f60183b upstream.

As Arjan pointed out, we mustn't do anything related to PCI
configuration until the device is properly enabled with
pci_enable_device().

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5:
  - file rename: drivers/net/wireless/iwlwifi/pcie/trans.c ->
    drivers/net/wireless/iwlwifi/iwl-trans-pcie.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 844d0f6..283b423 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2107,16 +2107,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->irq_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	/* W/A - seems to solve weird behavior. We need to remove this if we
-	 * don't want to stay in L1 all the time. This wastes a lot of power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
-
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_no_pci;
 	}
 
+	/* W/A - seems to solve weird behavior. We need to remove this if we
+	 * don't want to stay in L1 all the time. This wastes a lot of power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-- 
1.8.3.2


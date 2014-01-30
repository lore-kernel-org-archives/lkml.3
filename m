Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaA3Nrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaA3Nrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:47:35 -0500
Date: Thu, 30 Jan 2014 14:49:09 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 3/3] ath10k: Use pci_enable_msi_range()
Message-ID: <20140130134908.GC31909@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 563ce77..ad2a6cf 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2411,8 +2411,9 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 	/* Try MSI-X */
 	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO && msix_supported) {
 		ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
-		ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
-		if (ret == 0)
+		ret = pci_enable_msi_range(ar_pci->pdev, ar_pci->num_msi_intrs,
+							 ar_pci->num_msi_intrs);
+		if (ret > 0)
 			return 0;
 
 		/* fall-through */
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

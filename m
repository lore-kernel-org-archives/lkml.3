Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaA3Nq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:46:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaA3Nq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:46:56 -0500
Date: Thu, 30 Jan 2014 14:48:20 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
Message-ID: <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
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

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 29fd197..6525e1f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2414,8 +2414,6 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 		ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
 		if (ret == 0)
 			return 0;
-		if (ret > 0)
-			pci_disable_msi(ar_pci->pdev);
 
 		/* fall-through */
 	}
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

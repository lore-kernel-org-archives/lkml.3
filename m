Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaA3NrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaA3NrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:47:19 -0500
Date: Thu, 30 Jan 2014 14:48:54 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 2/3] ath10k: Disable MSI in case IRQ configuration is unknown
Message-ID: <20140130134853.GB31909@dhcp-26-207.brq.redhat.com>
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

In case IRQ configuration is unknown possibly enabled MSIs
are left enabled in ath10k_pci_deinit_irq(). This update
fixes the described misbehaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6525e1f..563ce77 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2480,6 +2480,8 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 	case MSI_NUM_REQUEST:
 		pci_disable_msi(ar_pci->pdev);
 		return 0;
+	default:
+		pci_disable_msi(ar_pci->pdev);
 	}
 
 	ath10k_warn("unknown irq configuration upon deinit\n");
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

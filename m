Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaHRIzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:55:11 -0400
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551AbaHRIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:08 -0400
X-Greylist: delayed 10355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 04:55:02 EDT
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, iss_storagedev@hp.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 01/13] hpsa: Fallback to MSI rather than to INTx if MSI-X failed
Date: Mon, 18 Aug 2014 08:01:41 +0200
Message-Id: <16baf29bf7cd9d45de63a4192a9ef9e87ba12936.1408335523.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver falls back to INTx mode when MSI-X
initialization failed. This is a suboptimal behaviour
for chips that also support MSI. This update changes that
behaviour and falls back to MSI mode in case MSI-X mode
initialization failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/hpsa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b35d0d..a9c4c9f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6176,7 +6176,6 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
 			h->msix_vector = 0;
-			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-- 
1.9.3


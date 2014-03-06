Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaCFUJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:09:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbaCFUJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:09:54 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 3/4] tsi721: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Thu,  6 Mar 2014 21:11:23 +0100
Message-Id: <d21563117d14900b2c094847198ff9a99e2e3dfa.1394128952.git.agordeev@redhat.com>
In-Reply-To: <cover.1394128952.git.agordeev@redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/rapidio/devices/tsi721.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index ff7cbf2..ce08e8d 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -768,15 +768,10 @@ static int tsi721_enable_msix(struct tsi721_device *priv)
 	}
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
-	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
+	err = pci_enable_msix_exact(priv->pdev, entries, ARRAY_SIZE(entries));
 	if (err) {
-		if (err > 0)
-			dev_info(&priv->pdev->dev,
-				 "Only %d MSI-X vectors available, "
-				 "not using MSI-X\n", err);
-		else
-			dev_err(&priv->pdev->dev,
-				"Failed to enable MSI-X (err=%d)\n", err);
+		dev_err(&priv->pdev->dev,
+			"Failed to enable MSI-X (err=%d)\n", err);
 		return err;
 	}
 
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3IJFLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:11:38 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47513 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab3IJFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:11:36 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH 3/3] staging: usbip: vhci_hcd: remove check for dma
Date: Tue, 10 Sep 2013 10:36:46 +0530
Message-Id: <1378789606-3386-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhci_hcd is a virtual usb host controller, so no need to
check for dma.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/vhci_hcd.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index b3c9217..e810ad5 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -999,12 +999,6 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 
 	usbip_dbg_vhci_hc("name %s id %d\n", pdev->name, pdev->id);
 
-	/* will be removed */
-	if (pdev->dev.dma_mask) {
-		dev_info(&pdev->dev, "vhci_hcd DMA not supported\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Allocate and initialize hcd.
 	 * Our private data is also allocated automatically.
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030980Ab3HIUB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:01:59 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:46397 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030931Ab3HIUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:01:57 -0400
X-Greylist: delayed 5908 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 16:01:57 EDT
From: Philippe De Swert <philippe.deswert@jollamobile.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Philippe De Swert <philippe.deswert@jollamobile.com>
Subject: [PATCH] mmc: sdhci-pci : Remove logically dead code
Date: Fri,  9 Aug 2013 23:01:46 +0300
Message-Id: <1376078506-10391-1-git-send-email-philippe.deswert@jollamobile.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amount of slots is calculated as follows:
slots = PCI_SLOT_INFO_SLOTS(slots) + 1;

Which means that just after it slots cannot be 0.

Found with coverity: CID#744269

Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
---
 drivers/mmc/host/sdhci-pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..9c76558 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1470,9 +1470,6 @@ static int sdhci_pci_probe(struct pci_dev *pdev,
 
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
-	if (slots == 0)
-		return -ENODEV;
-
 	BUG_ON(slots > MAX_SLOTS);
 
 	ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
-- 
1.8.1.2


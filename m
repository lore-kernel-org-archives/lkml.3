Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaDNWXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:23:35 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44250 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaDNWXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:23:32 -0400
Subject: [PATCH] mmc: sdhci-pci: Remove useless check for "slots == 0"
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2014 16:23:30 -0600
Message-ID: <20140414222330.14817.81724.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the check for "slots == 0" because it can never be 0 here.

Found by Coverity (CID 744269).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/mmc/host/sdhci-pci.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index fdc612120362..15edb3f56dae 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1491,8 +1491,6 @@ static int sdhci_pci_probe(struct pci_dev *pdev,
 
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
-	if (slots == 0)
-		return -ENODEV;
 
 	BUG_ON(slots > MAX_SLOTS);
 


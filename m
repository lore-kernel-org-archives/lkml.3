Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaH0Bsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:48:43 -0400
Received: from ks4000838.ip-198-245-63.net ([198.245.63.167]:44533 "EHLO
	lofn.phire.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbaH0Bsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:48:42 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2014 21:48:41 EDT
From: Michael Auchter <a@phire.org>
To: Michael Buesch <m@bues.ch>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Cc: Michael Auchter <a@phire.org>
Subject: [PATCH] gpio: bt8xx: fix release of managed resources
Date: Wed, 27 Aug 2014 01:39:33 +0000
Message-Id: <1409103573-4082-1-git-send-email-a@phire.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These resources are managed by devres, and should not be explicitly
released.

Signed-off-by: Michael Auchter <a@phire.org>
---
 drivers/gpio/gpio-bt8xx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index 6557147..7e4c43c 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -241,9 +241,6 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
 	bgwrite(~0x0, BT848_INT_STAT);
 	bgwrite(0x0, BT848_GPIO_OUT_EN);
 
-	iounmap(bg->mmio);
-	release_mem_region(pci_resource_start(pdev, 0),
-			   pci_resource_len(pdev, 0));
 	pci_disable_device(pdev);
 }
 
-- 
1.8.5.5


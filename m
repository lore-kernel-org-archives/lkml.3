Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaBSI4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaBSI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:37 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>, linux-pci@vger.kernel.org
Subject: [PATCH 3/9] mtip32xx: Remove superfluous call to pci_disable_msi()
Date: Wed, 19 Feb 2014 09:58:15 +0100
Message-Id: <eb0c7ed053e6e047d0d09ea7e803dd39a1ef71ed.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call pci_disable_msi() in case
the previous call to pci_enable_msi() failed

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/mtip32xx/mtip32xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5160269..5299a65 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4615,7 +4615,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	if (rv) {
 		dev_warn(&pdev->dev,
 			"Unable to enable MSI interrupt.\n");
-		goto block_initialize_err;
+		goto msi_initialize_err;
 	}
 
 	/* Initialize the block layer. */
@@ -4645,6 +4645,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 
 block_initialize_err:
 	pci_disable_msi(pdev);
+
+msi_initialize_err:
 	if (dd->isr_workq) {
 		flush_workqueue(dd->isr_workq);
 		destroy_workqueue(dd->isr_workq);
-- 
1.7.7.6


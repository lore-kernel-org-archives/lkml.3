Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaBSI4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaBSI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:37 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>, linux-pci@vger.kernel.org
Subject: [PATCH 4/9] mtip32xx: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 09:58:16 +0100
Message-Id: <02b7d83dfc12a519431e48ab54e448bafb4b29fe.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5299a65..60e86e8 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4611,8 +4611,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	INIT_WORK(&dd->work[7].work, mtip_workq_sdbf7);
 
 	pci_set_master(pdev);
-	rv = pci_enable_msi(pdev);
-	if (rv) {
+	rv = pci_enable_msi_range(pdev, 1, 1);
+	if (rv < 0) {
 		dev_warn(&pdev->dev,
 			"Unable to enable MSI interrupt.\n");
 		goto msi_initialize_err;
-- 
1.7.7.6


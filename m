Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBYVbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaBYVba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:31:30 -0500
Date: Tue, 25 Feb 2014 22:33:18 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Asai Thambi S P <asamymuthupa@micron.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 11/9] mtip32xx: Use pci_enable_msi() instead of
 pci_enable_msi_range()
Message-ID: <20140225213317.GB20652@dhcp-26-207.brq.redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "mtip32xx: Use pci_enable_msix_range() instead of
pci_enable_msix()" was unnecessary, since pci_enable_msi()
function is not deprecated and is still preferable for
enabling the single MSI mode. This update reverts usage of
pci_enable_msi() function.

Besides, the changelog for that commit was bogus, since
mtip32xx driver uses MSI interrupt, not MSI-X.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 60e86e8..5299a65 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4611,8 +4611,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	INIT_WORK(&dd->work[7].work, mtip_workq_sdbf7);
 
 	pci_set_master(pdev);
-	rv = pci_enable_msi_range(pdev, 1, 1);
-	if (rv < 0) {
+	rv = pci_enable_msi(pdev);
+	if (rv) {
 		dev_warn(&pdev->dev,
 			"Unable to enable MSI interrupt.\n");
 		goto msi_initialize_err;
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

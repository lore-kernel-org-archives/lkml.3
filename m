Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaBSKNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:13:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaBSKNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:46 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH] mic: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:24 +0100
Message-Id: <1392804931-30671-4-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/misc/mic/host/mic_intr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index f9c29bc..48f4426 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -194,9 +194,9 @@ static int mic_setup_msix(struct mic_device *mdev, struct pci_dev *pdev)
 	for (i = 0; i < MIC_MIN_MSIX; i++)
 		mdev->irq_info.msix_entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, mdev->irq_info.msix_entries,
-		MIC_MIN_MSIX);
-	if (rc) {
+	rc = pci_enable_msix_range(pdev, mdev->irq_info.msix_entries,
+				   MIC_MIN_MSIX, MIC_MIN_MSIX);
+	if (rc < 0) {
 		dev_dbg(&pdev->dev, "Error enabling MSIx. rc = %d\n", rc);
 		goto err_enable_msix;
 	}
-- 
1.7.7.6


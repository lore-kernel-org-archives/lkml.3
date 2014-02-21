Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaBUQVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaBUQVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:21:03 -0500
Date: Fri, 21 Feb 2014 17:22:59 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2] mic: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221162258.GB17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-4-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-4-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/misc/mic/host/mic_intr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index f9c29bc..dbc5afd 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -194,7 +194,7 @@ static int mic_setup_msix(struct mic_device *mdev, struct pci_dev *pdev)
 	for (i = 0; i < MIC_MIN_MSIX; i++)
 		mdev->irq_info.msix_entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, mdev->irq_info.msix_entries,
+	rc = pci_enable_msix_exact(pdev, mdev->irq_info.msix_entries,
 		MIC_MIN_MSIX);
 	if (rc) {
 		dev_dbg(&pdev->dev, "Error enabling MSIx. rc = %d\n", rc);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

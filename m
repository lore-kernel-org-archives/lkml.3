Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaDNIEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaDNIEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:04:20 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, intel-linux-scu@intel.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 08/23] isci: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 14 Apr 2014 10:05:32 +0200
Message-Id: <8a203f9f8b7844e46676d526188965e877751edb.1397461652.git.agordeev@redhat.com>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
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
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: intel-linux-scu@intel.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/isci/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 695b34e..4198e45 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -356,7 +356,7 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	for (i = 0; i < num_msix; i++)
 		pci_info->msix_entries[i].entry = i;
 
-	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
+	err = pci_enable_msix_exact(pdev, pci_info->msix_entries, num_msix);
 	if (err)
 		goto intx;
 
-- 
1.7.7.6


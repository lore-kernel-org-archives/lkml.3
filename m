Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaBXIO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:14:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaBXIBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:01:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, intel-linux-scu@intel.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 10/23] isci: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:10 +0100
Message-Id: <b6c5934fa5e2f17f49a48a38f036bcd5149455c6.1393191330.git.agordeev@redhat.com>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
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
index d25d0d8..ce40538 100644
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


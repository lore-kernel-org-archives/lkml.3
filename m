Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaAGVkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:40:14 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:50137 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754415AbaAGVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:39:53 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 16:39:39 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        ath10k@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 0/7] Phase out pci_enable_msi_block()
Date: Tue,  7 Jan 2014 19:05:35 +0100
Message-Id: <cover.1389103215.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of recent deprecation of MSI-X/MSI enablement
interfaces pci_enable_msi_block(), pci_enable_msi() and
pci_enable_msix() all drivers need to be updated to use
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

This is the first in a series of updates, to phase out
pci_enable_msi_block() function.

This series is against pci/msi branch in Bjorn Helgaas's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Thanks!

Alexander Gordeev (7):
  ipr: Do not call pci_disable_msi/msix() if pci_enable_msi/msix()
    failed
  ipr: Use new interfaces for MSI/MSI-X enablement
  ahci: Use new interfaces for MSI/MSI-X enablement
  nvme: Use new interfaces for MSI/MSI-X enablement
  vfio: Use new interfaces for MSI/MSI-X enablement
  ath10k: Use new interfaces for MSI enablement
  wil6210: Use new interfaces for MSI enablement

 drivers/ata/ahci.c                          |   15 +++-----
 drivers/block/nvme-core.c                   |   33 ++++-------------
 drivers/net/wireless/ath/ath10k/pci.c       |   22 ++++++------
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++---------
 drivers/scsi/ipr.c                          |   51 +++++++++-----------------
 drivers/vfio/pci/vfio_pci_intrs.c           |    8 ++--
 6 files changed, 66 insertions(+), 99 deletions(-)

-- 
1.7.7.6


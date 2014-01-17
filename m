Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaAQQVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:21:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbaAQQVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:21:01 -0500
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
Subject: [PATCH v2 0/9] Phase out pci_enable_msi_block()
Date: Fri, 17 Jan 2014 17:02:14 +0100
Message-Id: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against "next" branch in Bjorn's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Changes from v1 to v2:
  - added a regression fix "ahci: Fix broken fallback to single
    MSI mode" as patch 1/9;
  - the series is reordered to move the regression fix in front;
  - at Bjorn's request pci_enable_msi() is un-deprecated;
  - as result, pci_enable_msi_range(pdev, 1, 1) styled calls
    rolled back to pci_enable_msi(pdev);
  - nvme bug fix moved out as a separate patch 5/9 "nvme: Fix
    invalid call to irq_set_affinity_hint()"
  - patches changelog elaborated a bit;

Bjorn,

As the release is supposedly this weekend, do you prefer
the patches to go to your tree or to individual trees after
the release?

Thanks!

Alexander Gordeev (9):
  ahci: Fix broken fallback to single MSI mode
  ahci: Use pci_enable_msi_range()
  ipr: Get rid of superfluous call to pci_disable_msi/msix()
  ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
  nvme: Fix invalid call to irq_set_affinity_hint()
  nvme: Use pci_enable_msi_range() and pci_enable_msix_range()
  vfio: Use pci_enable_msi_range() and pci_enable_msix_range()
  ath10k: Use pci_enable_msi_range()
  wil6210: Use pci_enable_msi_range()

 drivers/ata/ahci.c                          |   18 +++++-----
 drivers/block/nvme-core.c                   |   33 ++++-------------
 drivers/net/wireless/ath/ath10k/pci.c       |   20 +++++-----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++---------
 drivers/scsi/ipr.c                          |   51 +++++++++-----------------
 drivers/vfio/pci/vfio_pci_intrs.c           |   12 ++++--
 6 files changed, 72 insertions(+), 98 deletions(-)

-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbaGCPvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaGCPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:51:15 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/7] iommu: Fix DMA alias problems
To: iommu@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2014 09:51:12 -0600
Message-ID: <20140703154428.8112.97562.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is effectively a resend of the iommu parts of the previously
combined iommu and pci v4 series.  The pci base changes are in, we
just need the iommu changes to make them effective.  These changes
have proven to solve numerous issues with devices that use the
wrong requester ID and bridges that fail to expose a PCIe capability.
After this is applied, we'll be able to remove a couple pci
interfaces, including the very broken pci_find_upstream_pcie_bridge.
Thanks,

Alex

---

Alex Williamson (7):
      iommu: Remove pci.h
      iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
      iommu/intel: Update to use PCI DMA aliases
      iommu/intel: Use iommu_group_get_for_dev()
      iommu/amd: Use iommu_group_get_for_dev()
      iommu/amd: Update to use PCI DMA aliases
      iommu: Create central IOMMU group lookup/creation interface


 drivers/iommu/amd_iommu.c           |  214 +++++++-----------------
 drivers/iommu/amd_iommu_types.h     |    1 
 drivers/iommu/fsl_pamu_domain.c     |   66 --------
 drivers/iommu/intel-iommu.c         |  307 +++++++++++++----------------------
 drivers/iommu/intel_irq_remapping.c |   55 ++++--
 drivers/iommu/iommu.c               |  182 +++++++++++++++++++++
 drivers/iommu/pci.h                 |   29 ---
 include/linux/iommu.h               |    1 
 8 files changed, 398 insertions(+), 457 deletions(-)
 delete mode 100644 drivers/iommu/pci.h

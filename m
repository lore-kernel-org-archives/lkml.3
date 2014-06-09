Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaFISB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaFISBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:01:53 -0400
Message-ID: <1402336882.14174.107.camel@ul30vt.home>
Subject: Re: [PATCH v4 00/16] PCI/iommu: Fix DMA alias problems
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>
Date: Mon, 09 Jun 2014 12:01:22 -0600
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
References: <20140522230230.2856.40017.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 17:07 -0600, Alex Williamson wrote:
> Alex Williamson (16):
>       PCI: Add DMA alias iterator
>       PCI: define pci_dev_flags as bit shifts
>       PCI: quirk pci_for_each_dma_alias()
>       PCI: quirk dma_alias_devfn for Ricoh devices
>       PCI: quirk dma_alias_devfn for Marvell devices
>       PCI: Quirk pci_for_each_dma_alias() for bridges
>       PCI: Add quirks for ASMedia and Tundra bridges


Hi Joerg & David,

Bjorn has accepted the above patches for v3.16 and they currently live
in his pci/iommu branch.  This series has been shown by numerous users
to make devices with buggy DMA issues work in the presence of an IOMMU
and it would be really great if we could get an opinion on both the
common IOMMU changes as well as the changes for AMD-Vi and Intel VT-d.
Varun has already ack'd the changes for fsl.  Please let us know how
you'd like to proceed.  Can we get acks and allow Bjorn to shepherd the
whole series in?  Would you prefer to pull the changes via your
respective trees and let Bjorn follow-up with the code removal?  Do you
have any outstanding issues with the patches to your areas?  Thanks,

Alex

>       iommu: Create central IOMMU group lookup/creation interface
>       iommu/amd: Update to use PCI DMA aliases
>       iommu/amd: Use iommu_group_get_for_dev()
>       iommu/intel: Use iommu_group_get_for_dev()
>       iommu/intel: Update to use PCI DMA aliases
>       iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
>       iommu: Remove pci.h
>       PCI: Remove pci_find_upstream_pcie_bridge()
>       PCI: Remove pci_get_dma_source()
> 
> 
>  drivers/iommu/amd_iommu.c           |  214 +++++++-----------------
>  drivers/iommu/amd_iommu_types.h     |    1 
>  drivers/iommu/fsl_pamu_domain.c     |   66 --------
>  drivers/iommu/intel-iommu.c         |  307 +++++++++++++----------------------
>  drivers/iommu/intel_irq_remapping.c |   55 ++++--
>  drivers/iommu/iommu.c               |  181 +++++++++++++++++++++
>  drivers/iommu/pci.h                 |   29 ---
>  drivers/pci/quirks.c                |  116 ++++++++-----
>  drivers/pci/search.c                |  104 +++++++++---
>  include/linux/iommu.h               |    1 
>  include/linux/pci.h                 |   31 +---
>  11 files changed, 557 insertions(+), 548 deletions(-)
>  delete mode 100644 drivers/iommu/pci.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




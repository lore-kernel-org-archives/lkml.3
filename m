Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaAHUnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:43:41 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58203 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbaAHUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:43:35 -0500
MIME-Version: 1.0
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Date: Wed, 8 Jan 2014 12:43:35 -0800
X-Google-Sender-Auth: bdTbUM1riEgg7FLvG1FiTGsdAeY
Message-ID: <CAE9FiQUgfuQ9nXNOOCcYAKVeN05o+TX6e35qe5nSkyxB-DpyGg@mail.gmail.com>
Subject: Re: [Patch Part2 V1 00/14] Enhance DMAR drivers to handle PCI/memory
 hotplug events
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 1:00 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Intel DMA/interrupt remapping drivers scan available PCI/memory devices
> at startup and cache discovered hardware topologies. They don't update
> cached information if PCI/memory hotplug event happens at runtime, then
> the stale information may break DMA/interrupt remapping logic.
>
> This patchset first (Patch 1-8) tries to introduces some helper
> functions and fixes several bugs, then (Patch 9,10) uses a global
> rwsem and RCU to protect global DMA/interrupt remapping data
> structures, and finally (Patch 11-14) hook PCI/memory hotplug events
> to update cached information.
>
> It's also a preparation for supporting of DMA/interrupt remapping
> hotplug.
>
> Jiang Liu (14):
>   iommu/vt-d: factor out dmar_alloc_dev_scope() for later reuse
>   iommu/vt-d: move private structures and variables into intel-iommu.c
>   iommu/vt-d: simplify function get_domain_for_dev()
>   iommu/vt-d: free resources if failed to create domain for PCIe
>     endpoint
>   iommu/vt-d: create device_domain_info structure for intermediate P2P
>     bridges
>   iommu/vt-d: fix incorrect iommu_count for si_domain
>   iommu/vt-d: fix error in detect ATS capability
>   iommu/vt-d: introduce macro for_each_dev_scope() to walk device scope
>     entries
>   iommu/vt-d: introduce a rwsem to protect global data structures
>   iommu/vt-d: use RCU to protect global resources in interrupt context
>   iommu/vt-d, PCI: update DRHD/RMRR/ATSR device scope caches when PCI
>     hotplug happens
>   iommu/vt-d, PCI: unify the way to process DMAR device scope array
>   iommu/vt-d: update device to static identity domain mapping for PCI
>     hotplug
>   iommu/vt-d: update IOMMU state when memory hotplug happens
>
>  drivers/iommu/dmar.c                |  412 +++++++++++++++++--------
>  drivers/iommu/intel-iommu.c         |  583 +++++++++++++++++++++--------------
>  drivers/iommu/intel_irq_remapping.c |  108 ++++---
>  include/linux/dmar.h                |   75 +++--
>  4 files changed, 753 insertions(+), 425 deletions(-)


Hi, Jiang,

What is relationship between your two patchset with my iommu hotplug patchset?

https://lkml.org/lkml/2014/1/2/527

or yours will just replace mine?

Thanks

Yinghai

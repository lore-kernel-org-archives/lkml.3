Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbaGWPe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:34:26 -0400
Received: from 8bytes.org ([81.169.241.247]:55928 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765AbaGWPeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:34:23 -0400
Date: Wed, 23 Jul 2014 17:34:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V4 16/21] iommu/vt-d: Implement DMAR unit hotplug
 framework
Message-ID: <20140723153420.GC14017@8bytes.org>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
 <1405059585-10620-17-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405059585-10620-17-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:19:40PM +0800, Jiang Liu wrote:
> On Intel platforms, an IO Hub (PCI/PCIe host bridge) may contain DMAR
> units, so we need to support DMAR hotplug when supporting PCI host
> bridge hotplug on Intel platforms.
> 
> According to Section 8.8 "Remapping Hardware Unit Hot Plug" in "Intel
> Virtualization Technology for Directed IO Architecture Specification
> Rev 2.2", ACPI BIOS should implement ACPI _DSM method under the ACPI
> object for the PCI host bridge to support DMAR hotplug.
> 
> This patch introduces interfaces to parse ACPI _DSM method for
> DMAR unit hotplug. It also implements state machines for DMAR unit
> hot-addition and hot-removal.
> 
> The PCI host bridge hotplug driver should call dmar_hotplug_hotplug()
> before scanning PCI devices connected for hot-addition and after
> destroying all PCI devices for hot-removal.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c                |  268 +++++++++++++++++++++++++++++++++--
>  drivers/iommu/intel-iommu.c         |   78 +++++++++-
>  drivers/iommu/intel_irq_remapping.c |    5 +
>  include/linux/dmar.h                |   33 +++++
>  4 files changed, 370 insertions(+), 14 deletions(-)

This patch triggers a compile error with allnoconfig on amd64:

  CC      arch/x86/kernel/pci-dma.o
In file included from arch/x86/kernel/pci-dma.c:3:0:
include/linux/dmar.h:168:35: error: unknown type name ‘acpi_handle’
 static inline int dmar_device_add(acpi_handle handle)
                                   ^
include/linux/dmar.h:173:38: error: unknown type name ‘acpi_handle’
 static inline int dmar_device_remove(acpi_handle handle)
                                      ^
make[2]: *** [arch/x86/kernel/pci-dma.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2


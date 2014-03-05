Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaCEHsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:48:12 -0500
Received: from 8bytes.org ([85.214.48.195]:60219 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaCEHsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:48:09 -0500
Date: Wed, 5 Mar 2014 08:48:04 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [Patch Part2 V2 00/17] Enhance DMAR drivers to handle PCI/memory
 hotplug events
Message-ID: <20140305074804.GE27471@8bytes.org>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar  5 08:48:07 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5316d6b720866998361632
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 02:07:20PM +0800, Jiang Liu wrote:
> Jiang Liu (17):
>   iommu/vt-d: avoid double free of g_iommus on error recovery path
>   iommu/vt-d: avoid caching stale domain_device_info and fix memory
>     leak
>   iommu/vt-d: avoid caching stale domain_device_info when hot-removing
>     PCI device
>   iommu/vt-d: factor out dmar_alloc_dev_scope() for later reuse
>   iommu/vt-d: move private structures and variables into intel-iommu.c
>   iommu/vt-d: simplify function get_domain_for_dev()
>   iommu/vt-d: free resources if failed to create domain for PCIe
>     endpoint
>   iommu/vt-d: reduce duplicated code to handle virtual machine domains
>   iommu/vt-d: fix incorrect iommu_count for si_domain
>   iommu/vt-d: check for NULL pointer when freeing IOMMU data structure
>   iommu/vt-d: fix error in detect ATS capability
>   iommu/vt-d: introduce macro for_each_dev_scope() to walk device scope
>     entries
>   iommu/vt-d: introduce a rwsem to protect global data structures
>   iommu/vt-d: use RCU to protect global resources in interrupt context
>   iommu/vt-d, PCI: update DRHD/RMRR/ATSR device scope caches when PCI
>     hotplug happens
>   iommu/vt-d, PCI: unify the way to process DMAR device scope array
>   iommu/vt-d: update IOMMU state when memory hotplug happens
> 
>  drivers/iommu/dmar.c                |  412 +++++++++++++------
>  drivers/iommu/intel-iommu.c         |  750 ++++++++++++++++++-----------------
>  drivers/iommu/intel_irq_remapping.c |  108 +++--
>  drivers/iommu/iova.c                |   64 ++-
>  include/linux/dmar.h                |   74 ++--
>  include/linux/iova.h                |    2 +
>  6 files changed, 848 insertions(+), 562 deletions(-)

Applied, thanks Jiang.



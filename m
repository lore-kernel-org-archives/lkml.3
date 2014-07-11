Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaGKGRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:17:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:55688 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaGKGRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333034"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part3 V4 00/21] Enable support of Intel DMAR device hotplug
Date: Fri, 11 Jul 2014 14:19:24 +0800
Message-Id: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot plugging a descrete IOH or a physical processor with embedded
IIO, we need to handle DMAR(or IOMMU) unit in the PCIe host bridge if
DMAR is in use. This patch set tries to enhance current DMAR/IOMMU/IR
drivers to support hotplug and is based on latest Joerg's iommu/next
branch.

Patch 1-13 are bugfixes and code improvement for current drivers.
Patch 14-17 enhances DMAR framework to support hotplug
Patch 18 enhances Intel interrupt remapping driver to support hotplug
Patch 19 enhances error handling in Intel IR driver
Patch 20 enhance Intel IOMMU to support hotplug
Patch 21 enhance ACPI pci_root driver to handle DMAR units

This patch set has been tested on Intel development machine.
Appreciate any comments and tests. With this patch set and
another IOAPIC hotplug patch set(http://www.mail-archive.com/linux-kernel
@vger.kernel.org/msg671316.html) applied, we could support full functional
socket hotplug on x86 platforms now.

V3->V4:
1) rebase onto iommu/next branch to solve conflicts
2) refine commit messages according to Bjorn's suggestion.

V2->V3:
1) rebase to latest v3.16-rc2
2) fix a bug in detecting super page support when hot-adding IOMMU

V1->V2:
1) enhance the way to simplify intel_unmap_sg()
2) rename dmar_device_hotplug() to dmar_device_add/remove()
3) coding style improvment

Best Regards!

Jiang Liu (21):
  iommu/vt-d: Match segment number when searching for dev_iotlb capable
    devices
  iommu/vt-d: Use correct domain id to flush virtual machine domains
  iommu/vt-d: Introduce helper functions to improve code readability
  iommu/vt-d: Introduce helper functions to make code symmetric for
    readability
  iommu/vt-d: Allocate dynamic domain id for virtual domains only
  iommu/vt-d: Fix possible invalid memory access caused by
    free_dmar_iommu()
  iommu/vt-d: Avoid freeing virtual machine domain in free_dmar_iommu()
  iommu/vt-d: Simplify include/linux/dmar.h
  iommu/vt-d: Change iommu_enable/disable_translation to return void
  iommu/vt-d: Simplify intel_unmap_sg() and kill duplicated code
  iommu/vt-d: Introduce helper domain_pfn_within_range() to simplify
    code
  iommu/vt-d: Introduce helper function iova_size() to improve code
    readability
  iommu/vt-d: Fix issue in computing domain's iommu_snooping flag
  iommu/vt-d: Introduce helper function dmar_walk_resources()
  iommu/vt-d: Dynamically allocate and free seq_id for DMAR units
  iommu/vt-d: Implement DMAR unit hotplug framework
  iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
  iommu/vt-d: Enhance intel_irq_remapping driver to support DMAR unit
    hotplug
  iommu/vt-d: Enhance error recovery in function
    intel_enable_irq_remapping()
  iommu/vt-d: Enhance intel-iommu driver to support DMAR unit hotplug
  pci, ACPI, iommu: Enhance pci_root to support DMAR device hotplug

 drivers/acpi/pci_root.c             |   16 +-
 drivers/iommu/dmar.c                |  531 ++++++++++++++++++++------
 drivers/iommu/intel-iommu.c         |  720 +++++++++++++++++++++--------------
 drivers/iommu/intel_irq_remapping.c |  233 +++++++++---
 include/linux/dmar.h                |   86 +++--
 include/linux/iova.h                |    5 +
 6 files changed, 1104 insertions(+), 487 deletions(-)

-- 
1.7.10.4


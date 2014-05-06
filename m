Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbaEFHDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:03:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:34948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933838AbaEFHDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526661916"
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
Subject: [Patch Part3 V2 00/21] Enable support of Intel DMAR device hotplug
Date: Tue,  6 May 2014 15:05:11 +0800
Message-Id: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot plugging a descrete IOH or a physical processor with embedded
IIO, we need to handle DMAR(or IOMMU) unit in the PCIe host bridge if
DMAR is in use. This patch set tries to enhance current DMAR/IOMMU/IR
drivers to support hotplug and is based on latest mainstream kernel
v3.15-rc3-177-g0384dcae2b18.

Patch 1-13 are bugfixes and code improvement for current drivers.
Patch 14-17 enhances DMAR framework to support hotplug
Patch 18 enhances Intel interrupt remapping driver to support hotplug
Patch 19 enhances error handling in Intel IR driver
Patch 20 enhance Intel IOMMU to support hotplug
Patch 21 enhance ACPI pci_root driver to handle DMAR units

This patch set has been tested on Intel development machine.
Appreciate any comments and tests.

V1->V2:
1) enhance the way to simplify intel_unmap_sg()
2) rename dmar_device_hotplug() to dmar_device_add/remove()
3) coding style improvment

Best Regards!

Jiang Liu (21):
  iommu/vt-d: match segment number when searching for dev_iotlb capable
    devices
  iommu/vt-d: use correct domain id to flush virtual machine domains
  iommu/vt-d: introduce helper functions to improve code readability
  iommu/vt-d: introduce helper functions to make code symmetric for
    readability
  iommu/vt-d: only dynamically allocate domain id for virtual domains
  iommu/vt-d: fix possible invalid memory access caused by
    free_dmar_iommu()
  iommu/vt-d: avoid freeing virtual machine domain in free_dmar_iommu()
  iommu/VT-d: simplify include/linux/dmar.h
  iommu/vt-d: change iommu_enable/disable_translation to return void
  iommu/vt-d: simplify intel_unmap_sg() and kill duplicated code
  iommu/vt-d: introduce helper domain_pfn_within_range() to simplify
    code
  iommu/vt-d: introduce helper function iova_size() to improve code
    readability
  iommu/vt-d: fix bug in computing domain's iommu_snooping flag
  IOMMU/vt-d: introduce helper function dmar_walk_resources()
  iommu/vt-d: dynamically allocate and free seq_id for DMAR units
  iommu/vt-d: implement DMAR unit hotplug framework
  iommu/vt-d: search _DSM method for DMAR hotplug
  iommu/vt-d: enhance intel_irq_remapping driver to support DMAR unit
    hotplug
  iommu/vt-d: enhance error recovery in function
    intel_enable_irq_remapping()
  iommu/vt-d: enhance intel-iommu driver to support DMAR unit hotplug
  pci, ACPI, iommu: enhance pci_root to support DMAR device hotplug

 drivers/acpi/pci_root.c             |   16 +-
 drivers/iommu/dmar.c                |  531 +++++++++++++++++++------
 drivers/iommu/intel-iommu.c         |  725 +++++++++++++++++++++--------------
 drivers/iommu/intel_irq_remapping.c |  233 ++++++++---
 include/linux/dmar.h                |   86 +++--
 include/linux/iova.h                |    5 +
 6 files changed, 1105 insertions(+), 491 deletions(-)

-- 
1.7.10.4


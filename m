Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaDVHFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:05:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:49541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaDVHFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,902,1389772800"; 
   d="scan'208";a="517081259"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [RFC Patch Part3 V1 00/22] Enable Intel DMAR device hotplug
Date: Tue, 22 Apr 2014 15:07:11 +0800
Message-Id: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot plugging a descrete IOH or a physical processor with embedded
IIO, we need to handle DMAR(or IOMMU) unit in the PCIe host bridge if
DMAR is in use. This patch set tries to enhance current DMAR/IOMMU/IR
drivers to support hotplug and is based on latest mainstream kernel
v3.15-rc2-36-gc089b229dfdd.

Patch 1-9 are bugfixes and code improvement for current drivers.
Patch 10-13 enhances DMAR framework to support hotplug
Patch 14 enhances Intel interrupt remapping driver to support hotplug
Patch 15 enhances error handling in Intel IR driver
Patch 16 enhance Intel IOMMU to support hotplug
Patch 17 enhance ACPI pci_root driver to handle DMAR units
Patch 18-22 are bugfixes and code improvement again

This patch set has been tested on Intel development machine.
Appreciate any comments and tests.

Best Regards!

Jiang Liu (22):
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
  iommu/vt-d: dynamically allocate and free seq_id for DMAR units
  IOMMU/vt-d: introduce helper function dmar_walk_resources()
  iommu/vt-d: implement DMAR unit hotplug framework
  iommu/vt-d: search _DSM method for DMAR hotplug
  iommu/vt-d: enhance intel_irq_remapping driver to support DMAR unit
    hotplug
  iommu/vt-d: enhance error recovery in function
    intel_enable_irq_remapping()
  iommu/vt-d: enhance intel-iommu driver to support DMAR unit hotplug
  pci, ACPI, iommu: enhance pci_root to support DMAR device hotplug
  iommu/vt-d: update proximity information when a new node with memory
    available
  iommu/vt-d: simplify intel_unmap_sg() and kill duplicated code
  iommu/vt-d: introduce helper domain_pfn_within_range() to simplify
    code
  iommu/vt-d: introduce helper function iova_size() to improve code
    readability
  iommu/vt-d: fix bug in computing domain's iommu_snooping flag

 drivers/acpi/pci_root.c             |   16 +-
 drivers/iommu/dmar.c                |  568 ++++++++++++++++++++++------
 drivers/iommu/intel-iommu.c         |  711 +++++++++++++++++++++--------------
 drivers/iommu/intel_irq_remapping.c |  233 +++++++++---
 include/linux/dmar.h                |   80 ++--
 include/linux/intel-iommu.h         |    1 +
 include/linux/iova.h                |    5 +
 7 files changed, 1133 insertions(+), 481 deletions(-)

-- 
1.7.10.4


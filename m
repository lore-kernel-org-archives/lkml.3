Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaILCIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:08:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:61409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaILCIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="590198340"
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
Subject: [Patch Part3 V5 0/8] Enable support of Intel DMAR device hotplug
Date: Fri, 12 Sep 2014 10:10:40 +0800
Message-Id: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot plugging a descrete IOH or a physical processor with embedded
IIO, we need to handle DMAR(or IOMMU) unit in the PCIe host bridge if
DMAR is in use. This patch set tries to enhance current DMAR/IOMMU/IR
drivers to support hotplug and is based on latest Linus master branch.

All prerequisite patches to support DMAR device hotplug have been merged
into the mainstream kernel, and this is the last patch set to enable
DMAR device hotplug.

You may access the patch set at:
https://github.com/jiangliu/linux.git iommu/hotplug_v5

This patch set has been tested on Intel development machine.
Appreciate any comments and tests.

Patch 1-4 enhances DMAR framework to support hotplug
Patch 5 enhances Intel interrupt remapping driver to support hotplug
Patch 6 enhances error handling in Intel IR driver
Patch 7 enhance Intel IOMMU to support hotplug
Patch 8 enhance ACPI pci_root driver to handle DMAR units

Jiang Liu (8):
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
 drivers/iommu/dmar.c                |  532 ++++++++++++++++++++++++++++-------
 drivers/iommu/intel-iommu.c         |  297 ++++++++++++++-----
 drivers/iommu/intel_irq_remapping.c |  233 +++++++++++----
 include/linux/dmar.h                |   50 +++-
 5 files changed, 888 insertions(+), 240 deletions(-)

-- 
1.7.10.4


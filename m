Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaAFGRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:17:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:53505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaAFGRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364777"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 00/20] Bugfixes and improvements for Intel IOMMU drivers
Date: Mon,  6 Jan 2014 14:18:07 +0800
Message-Id: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes several bugfixes and code improvements for
Intel DMA remapping and interrupt remapping drivers. It's also a
preparation for Intel IOMMU device hotplug.

It applies to the latest mainstream kernel on top of
	commit 7e3528c3660a2e8602abc7858b0994d611f74bc3

It has been tested on Intel SandyBridge and Romley-4S platforms.

Thanks!

V2->V3:
1) address review comments of last round

Jiang Liu (20):
  iommu/vt-d: use dedicated bitmap to track remapping entry allocation
    status
  iommu/vt-d: fix PCI device reference leakage on error recovery path
  iommu/vt-d: fix a race window in allocating domain ID for virtual
    machines
  iommu/vt-d: fix resource leakage on error recovery path in
    iommu_init_domains()
  iommu/vt-d, trivial: refine support of 64bit guest address
  iommu/vt-d, trivial: print correct domain id of static identity
    domain
  iommu/vt-d, trivial: check suitable flag in function
    detect_intel_iommu()
  iommu/vt-d, trivial: clean up unused code
  iommu/vt-d: mark internal functions as static
  iommu/vt-d, trivial: use defined macro instead of hardcoding
  iommu/vt-d, trivial: simplify code with existing macros
  iommu/vt-d: fix invalid memory access when freeing DMAR irq
  iommu/vt-d: keep shared resources when failed to initialize iommu
    devices
  iommu/vt-d: avoid double free in error recovery path
  iommu/vt-d: fix access after free issue in function free_dmar_iommu()
  iommu/vt-d: release invalidation queue when destroying IOMMU unit
  iommu/vt-d: fix wrong return value of dmar_table_init()
  iommu/vt-d, PCI, trivial: use dev_is_pci() instead of hardcoding
  iommu/vt-d, trivial: clean sparse warnings
  iommu/vt-d: free all resources if failed to initialize DMARs

 drivers/iommu/dmar.c                |  137 +++++++++++++--------
 drivers/iommu/intel-iommu.c         |  232 ++++++++++++++---------------------
 drivers/iommu/intel_irq_remapping.c |   98 +++++++--------
 drivers/iommu/irq_remapping.c       |    6 +-
 include/linux/dma_remapping.h       |    4 -
 include/linux/dmar.h                |   17 +--
 include/linux/intel-iommu.h         |    3 +-
 7 files changed, 229 insertions(+), 268 deletions(-)

-- 
1.7.10.4


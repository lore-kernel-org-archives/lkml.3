Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3LFDU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:20:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:55222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3LFDUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:20:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986866"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 00/20] Bugfixes and improvements for Intel IOMMU drivers
Date: Fri,  6 Dec 2013 11:21:03 +0800
Message-Id: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
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
1) Add three more patches 18, 19, 20
2) Fix minor bugs in previous version

V1->V2:
1) drop one wrong bugfix of " fix remapping interrupt handle leakage in
 error recovery path"
2) Kill redundant call of bitmap_allocate_region().
3) Add two new bugfixes.

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

 drivers/iommu/dmar.c                |  126 ++++++++++++--------
 drivers/iommu/intel-iommu.c         |  220 +++++++++++++----------------------
 drivers/iommu/intel_irq_remapping.c |   92 +++++++--------
 drivers/iommu/irq_remapping.c       |    6 +-
 include/linux/dma_remapping.h       |    4 -
 include/linux/dmar.h                |   17 +--
 include/linux/intel-iommu.h         |    3 +-
 7 files changed, 213 insertions(+), 255 deletions(-)

-- 
1.7.10.4


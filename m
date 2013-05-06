Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3EFHWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:22:24 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37509 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EFHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:22:22 -0400
From: aik@ozlabs.ru
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 0/5] VFIO PPC64: add VFIO support on POWERPC64
Date: Mon,  6 May 2013 17:21:56 +1000
Message-Id: <51875a2c.25ac440a.50d9.ffffe8eb@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The series adds support for VFIO on POWERPC in user space (such as QEMU).
The in-kernel real mode IOMMU support is added by another series posted
separately.

As the first and main aim of this series is the POWERNV platform support,
the "Enable on POWERNV platform" patch goes first and introduces an API
to be used by the VFIO IOMMU driver. The "Enable on pSeries platform" patch
simply registers PHBs in the IOMMU subsystem and expects the API to be present,
it enables VFIO support in fully emulated QEMU guests.

These patches were tested against 3.8 and the "iommu: Move initialization earlier"
patch is already in 3.9 so I am including it here only for the reference.

Change log:
* cleanups and minor fixes
* added support for pSeries
* separated from in-kernel IOMMU handling series (should make it easier to get sob'ed)
* signed-off-by Paul Mackerras

Alexey Kardashevskiy (5):
  iommu: Move initialization earlier
  KVM: PPC: iommu: Add missing
    kvm_iommu_map_pages/kvm_iommu_unmap_pages
  powerpc/vfio: Enable on POWERNV platform
  powerpc/vfio: Implement IOMMU driver for VFIO
  powerpc/vfio: Enable on pSeries platform

 Documentation/vfio.txt                      |   63 +++++
 arch/powerpc/include/asm/iommu.h            |   26 ++
 arch/powerpc/include/asm/kvm_host.h         |   14 +
 arch/powerpc/kernel/iommu.c                 |  319 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/pci-ioda.c   |    1 +
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |    5 +-
 arch/powerpc/platforms/powernv/pci.c        |    2 +
 arch/powerpc/platforms/pseries/iommu.c      |    4 +
 drivers/iommu/Kconfig                       |    8 +
 drivers/iommu/iommu.c                       |    2 +-
 drivers/vfio/Kconfig                        |    6 +
 drivers/vfio/Makefile                       |    1 +
 drivers/vfio/vfio.c                         |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c         |  377 +++++++++++++++++++++++++++
 include/uapi/linux/vfio.h                   |   34 +++
 15 files changed, 861 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

-- 
1.7.10.4


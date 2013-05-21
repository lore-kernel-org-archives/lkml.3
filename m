Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3EUDdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:33:22 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:43205 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3EUDdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:33:21 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5 v2] VFIO PPC64: add VFIO support on POWERPC64
Date: Tue, 21 May 2013 13:33:08 +1000
Message-Id: <1369107191-28547-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series adds support for VFIO on POWERPC in user space (such as QEMU).
The in-kernel real mode IOMMU support is added by another series posted
separately.

As the first and main aim of this series is the POWERNV platform support,
the "Enable on POWERNV platform" patch goes first and introduces an API
to be used by the VFIO IOMMU driver. The "Enable on pSeries platform" patch
simply registers PHBs in the IOMMU subsystem and expects the API to be present,
it enables VFIO support in fully emulated QEMU guests.

The main change is that this series was changed and tested against v3.10-rc1.
It also contains some bugfixes which are mentioned (if any) in the patch messages.

Alexey Kardashevskiy (3):
  powerpc/vfio: Enable on POWERNV platform
  powerpc/vfio: Implement IOMMU driver for VFIO
  powerpc/vfio: Enable on pSeries platform

 Documentation/vfio.txt                      |   63 +++++
 arch/powerpc/include/asm/iommu.h            |   26 ++
 arch/powerpc/kernel/iommu.c                 |  323 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/pci-ioda.c   |    1 +
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |    5 +-
 arch/powerpc/platforms/powernv/pci.c        |    2 +
 arch/powerpc/platforms/pseries/iommu.c      |    4 +
 drivers/iommu/Kconfig                       |    8 +
 drivers/vfio/Kconfig                        |    6 +
 drivers/vfio/Makefile                       |    1 +
 drivers/vfio/vfio.c                         |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c         |  377 +++++++++++++++++++++++++++
 include/uapi/linux/vfio.h                   |   34 +++
 13 files changed, 850 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

-- 
1.7.10.4


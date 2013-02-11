Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3BKLzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:55:15 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:33497 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3BKLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:55:13 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 0/2] vfio on power
Date: Mon, 11 Feb 2013 22:54:30 +1100
Message-Id: <1360583672-21924-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series introduces a VFIO support on POWER.
The QEMU support is required, the real mode acceleration patches are coming later.

Alexey Kardashevskiy (2):
  vfio powerpc: enabled on powernv platform
  vfio powerpc: implemented IOMMU driver for VFIO

 arch/powerpc/include/asm/iommu.h            |   15 ++
 arch/powerpc/kernel/iommu.c                 |  343 +++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/pci-ioda.c   |    1 +
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |    5 +-
 arch/powerpc/platforms/powernv/pci.c        |    3 +
 drivers/iommu/Kconfig                       |    8 +
 drivers/vfio/Kconfig                        |    6 +
 drivers/vfio/Makefile                       |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c         |  269 +++++++++++++++++++++
 include/uapi/linux/vfio.h                   |   31 +++
 10 files changed, 681 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

-- 
1.7.10.4


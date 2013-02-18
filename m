Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3BRNAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:00:33 -0500
Received: from [216.32.180.184] ([216.32.180.184]:5224 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab3BRNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:00:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizd799hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <joro@8bytes.org>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Mon, 18 Feb 2013 18:22:13 +0530
Message-ID: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides the Freescale PAMU (Peripheral Access Management Unit) driver
and the corresponding IOMMU API implementation. PAMU is the IOMMU present on Freescale
QorIQ platforms. PAMU can authorize memory access, remap the memory address, and remap 
the I/O transaction type.

This set consists of the following patches:
1. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
   pointer. This pointer is stored when the device is attached to a particular iommu domain.
2. Store PCI controller platform device information in the PCI controller structure.
3. Add defines for FSL PCI controller BRR1 register.
4. Add window permission flags in the iommu_domain_window_enable API.
5. Add domain attributes for FSL PAMU driver.
6. PAMU driver and IOMMU API implementation.

This patch set is based on the next branch of the iommu git tree maintained by Joerg.

Varun Sethi (6):
  Store iommu domain information in the device structure.
  Store the platform device information corresponding to the pci
    controller.
  Added defines for the FSL PCI controller BRR1 register.
  Add window permission flags for iommu_domain_window_enable API.
  Add addtional attributes specific to the PAMU driver.
  FSL PAMU driver and IOMMU API implementation.

 arch/powerpc/include/asm/device.h     |    4 +
 arch/powerpc/include/asm/pci-bridge.h |    4 +
 arch/powerpc/sysdev/fsl_pci.c         |    9 +-
 arch/powerpc/sysdev/fsl_pci.h         |    2 +-
 drivers/iommu/Kconfig                 |    8 +
 drivers/iommu/Makefile                |    1 +
 drivers/iommu/fsl_pamu.c              | 1260 +++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h              |  398 +++++++++++
 drivers/iommu/fsl_pamu_domain.c       | 1135 +++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h       |   89 +++
 drivers/iommu/iommu.c                 |    5 +-
 include/linux/iommu.h                 |   40 +-
 12 files changed, 2947 insertions(+), 8 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

-- 
1.7.4.1



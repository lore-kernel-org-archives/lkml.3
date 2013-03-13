Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab3CMSyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:54:05 -0400
Received: from [213.199.154.186] ([213.199.154.186]:34853 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933043Ab3CMSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:54:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizd799hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <scottwood@freescale.com>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/5 v9] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Thu, 14 Mar 2013 00:15:05 +0530
Message-ID: <1363200310-11513-1-git-send-email-Varun.Sethi@freescale.com>
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
1.  Make iova u64 in the iommu_iova_to_phys API.
2. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
   pointer.
3. Add window permission flags in the iommu_domain_window_enable API.
4. Add domain attributes for FSL PAMU driver.
5. PAMU driver and IOMMU API implementation.

This patch set is based on the master branch (3.9-rc2) of Linus Torvald's git tree.

Varun Sethi (5):
  Make iova u64 in the iommu_iova_to_phys API.
  Add iommu domain pointer to device archdata
  Add the window permission flag as a parameter to iommu_window_enable
  API.
  Add addition iommu attributes required by the PAMU driver.
  FSL PAMU driver.

 arch/powerpc/include/asm/device.h |    6 +
 arch/powerpc/sysdev/fsl_pci.h     |    5 +
 drivers/iommu/Kconfig             |    8 +
 drivers/iommu/Makefile            |    1 +
 drivers/iommu/amd_iommu.c         |    2 +-
 drivers/iommu/exynos-iommu.c      |    2 +-
 drivers/iommu/fsl_pamu.c          | 1250 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h          |  405 ++++++++++++
 drivers/iommu/fsl_pamu_domain.c   | 1134 +++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h   |   85 +++
 drivers/iommu/intel-iommu.c       |    2 +-
 drivers/iommu/iommu.c             |    8 +-
 drivers/iommu/msm_iommu.c         |    2 +-
 drivers/iommu/omap-iommu.c        |    2 +-
 drivers/iommu/shmobile-iommu.c    |    2 +-
 drivers/iommu/tegra-gart.c        |    2 +-
 drivers/iommu/tegra-smmu.c        |    2 +-
 include/linux/iommu.h             |   51 ++-
 18 files changed, 2948 insertions(+), 21 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

-- 
1.7.4.1



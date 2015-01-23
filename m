Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbbAWWeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:34:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53174 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbbAWWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:46 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 0/6] PCI: get DMA configuration from parent device
Date: Fri, 23 Jan 2015 17:32:33 -0500
Message-ID: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
and dma ops etc using the information from DT. The prior RFCs and discussions
are available at [1] and [2] below.

[2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
[1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591

Change history:
	v4 - moved size adjustments in of_iommu_configure() to a separate patch
	   - consistent node name comment from Rob
	   - patch 6 added for dma_mask adjustment and iommu mapping size
	     limiting.
	v3 - addressed comments to re-use of_dma_configure() for PCI
	   - To help re-use, change of_iommu_configure() function argument
		- Move of_dma_configure to of/device.c
		- Limit the of_iommu_configure to non pci devices
	v2 - update size to coherent_dma_mask + 1 if dma-range info is missing
	   - also check the np for null.
	v1 - updates based on the comments against initial RFC.
	   - Added a helper function to get the OF node of the parent
	   - Added an API in of_pci.c to update DMA configuration of the pci
	     device.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Murali Karicheri (6): 
  of: iommu: add ptr to OF node arg to of_iommu_configure()
  of: move of_dma_configure() to device.c to help re-use
  of: fix size when dma-range is not used
  of/pci: add of_pci_dma_configure() update dma configuration
  PCI: update dma configuration from DT
  arm: dma-mapping: updates to limit dma_mask and iommu mapping size

 arch/arm/mm/dma-mapping.c |   10 +++++++
 drivers/iommu/of_iommu.c  |   10 +++++--
 drivers/of/device.c       |   71 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c       |   39 +++++++++++++++++++++++++
 drivers/of/platform.c     |   58 ++----------------------------------
 drivers/pci/probe.c       |    2 ++
 include/linux/of_device.h |    2 ++
 include/linux/of_iommu.h  |    6 ++--
 include/linux/of_pci.h    |   12 ++++++++
 9 files changed, 150 insertions(+), 60 deletions(-)

-- 
1.7.9.5


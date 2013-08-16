Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3HPKIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:08:16 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34435 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HPKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:08:14 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: aik@ozlabs.ru, benh@au1.ibm.com, paulus@au1.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 0/2] powerpc/iommu: check dev->iommu_group before remove it
Date: Fri, 16 Aug 2013 18:08:05 +0800
Message-Id: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081621-3568-0000-0000-00000417D70D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had a talk with Alexey, who suggest me to send this for comments.

On powernv platform, the P7IOC provide limited range of DMA space. For
example, there are only 8 DMA segments on each PHB. When there are more 
than 8 PEs, some of PE's tce32_table is not initialized.

In the normal case, 8 PE is enough. If VF is enabled, 8 is not enough. This
lead to some pci_dev's iommu_table_base is NULL. Which results this device
couldn't be added to any iommu_group, and finally dev->iommu_group is left NULL.
When this VF is removed from the system, this will case kernel crash.

These two patches add the check to guard the kernel. Comments are welcome for
which place is better.

One more comment from Alexey is where we allow these non-DMA capable device
exist in the system. Maybe we should not allow to create a pci_dev for those
who can't get proper DMA space. Your comments are welcome :-)

Thanks in advance.

Wei Yang (2):
  iommu: Don't remove device when no iommu_group associated
  powerpc/iommu: check dev->iommu_group before remove a device from
    iommu_group

 arch/powerpc/kernel/iommu.c |    3 ++-
 drivers/iommu/iommu.c       |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

-- 
1.7.5.4


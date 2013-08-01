Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3HAEot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:44:49 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51982 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3HAEor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:44:47 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 00/10 v7] KVM: PPC: IOMMU in-kernel handling
Date: Thu,  1 Aug 2013 14:44:22 +1000
Message-Id: <1375332272-22176-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This accelerates VFIO DMA operations on POWER by moving them
into kernel.

The changes in this series are:
1. rebased on v3.11-rc3.
2. VFIO external user API will go through VFIO tree so it is
excluded from this series.
3. As nobody ever reacted on "hashtable: add hash_for_each_possible_rcu_notrace()",
Ben suggested to push it via his tree so I included it to the series.
4. realmode_(get|put)_page is reworked.

More details in the individual patch comments.

Alexey Kardashevskiy (10):
  hashtable: add hash_for_each_possible_rcu_notrace()
  KVM: PPC: reserve a capability number for multitce support
  KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
  powerpc: Prepare to support kernel handling of IOMMU map/unmap
  powerpc: add real mode support for dma operations on powernv
  KVM: PPC: enable IOMMU_API for KVM_BOOK3S_64 permanently
  KVM: PPC: Add support for multiple-TCE hcalls
  powerpc/iommu: rework to support realmode
  KVM: PPC: Add support for IOMMU in-kernel handling
  KVM: PPC: Add hugepage support for IOMMU in-kernel handling

 Documentation/virtual/kvm/api.txt         |  52 +++
 arch/powerpc/include/asm/iommu.h          |   9 +-
 arch/powerpc/include/asm/kvm_host.h       |  37 +++
 arch/powerpc/include/asm/kvm_ppc.h        |  18 +-
 arch/powerpc/include/asm/machdep.h        |  12 +
 arch/powerpc/include/asm/pgtable-ppc64.h  |   2 +
 arch/powerpc/include/uapi/asm/kvm.h       |   7 +
 arch/powerpc/kernel/iommu.c               | 202 +++++++----
 arch/powerpc/kvm/Kconfig                  |   1 +
 arch/powerpc/kvm/book3s_64_vio.c          | 533 +++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 405 +++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c              |  41 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |   8 +-
 arch/powerpc/kvm/book3s_pr_papr.c         |  35 ++
 arch/powerpc/kvm/powerpc.c                |  15 +
 arch/powerpc/mm/init_64.c                 |  50 ++-
 arch/powerpc/platforms/powernv/pci-ioda.c |  47 ++-
 arch/powerpc/platforms/powernv/pci.c      |  38 ++-
 arch/powerpc/platforms/powernv/pci.h      |   3 +-
 include/linux/hashtable.h                 |  15 +
 include/linux/mm.h                        |  14 +
 include/linux/page-flags.h                |   4 +-
 include/uapi/linux/kvm.h                  |   5 +
 23 files changed, 1430 insertions(+), 123 deletions(-)

-- 
1.8.3.2


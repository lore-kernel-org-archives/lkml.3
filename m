Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3GPAyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:54:20 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54809 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3GPAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:54:18 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 00/10 v6] KVM: PPC: IOMMU in-kernel handling
Date: Tue, 16 Jul 2013 10:53:55 +1000
Message-Id: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes are:
1. rebased on v3.11-rc1 so the capability numbers changed again
2. fixed multiple comments from maintainers
3. "KVM: PPC: Add support for IOMMU in-kernel handling" is split into
2 patches, the new one is "powerpc/iommu: rework to support realmode".
4. IOMMU_API is now always enabled for KVM_BOOK3S_64.

MOre details in the individual patch comments.

Depends on "hashtable: add hash_for_each_possible_rcu_notrace()",
posted a while ago.


Alexey Kardashevskiy (10):
  KVM: PPC: reserve a capability number for multitce support
  KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
  vfio: add external user support
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
 arch/powerpc/include/asm/pgtable-ppc64.h  |   4 +
 arch/powerpc/include/uapi/asm/kvm.h       |   7 +
 arch/powerpc/kernel/iommu.c               | 201 +++++++----
 arch/powerpc/kvm/Kconfig                  |   1 +
 arch/powerpc/kvm/book3s_64_vio.c          | 533 +++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 404 ++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c              |  41 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |   8 +-
 arch/powerpc/kvm/book3s_pr_papr.c         |  35 ++
 arch/powerpc/kvm/powerpc.c                |  15 +
 arch/powerpc/mm/init_64.c                 |  76 ++++-
 arch/powerpc/platforms/powernv/pci-ioda.c |  47 ++-
 arch/powerpc/platforms/powernv/pci.c      |  38 ++-
 arch/powerpc/platforms/powernv/pci.h      |   3 +-
 drivers/vfio/vfio.c                       |  62 ++++
 include/linux/page-flags.h                |   4 +-
 include/linux/vfio.h                      |   7 +
 include/uapi/linux/kvm.h                  |   5 +
 23 files changed, 1496 insertions(+), 123 deletions(-)

-- 
1.8.3.2


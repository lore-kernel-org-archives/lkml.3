Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab3GFPHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 11:07:22 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:46719 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3GFPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:07:20 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 0/8 v5]  KVM: PPC: IOMMU in-kernel handling
Date: Sun,  7 Jul 2013 01:06:59 +1000
Message-Id: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes are:
1. rebased on v3.10
2. added arch_spin_locks to protect TCE table in real mode
3. reworked VFIO external API
4. added missing bits for real mode handling of TCE requests on p7ioc

MOre details in the individual patch comments.

Depends on "hashtable: add hash_for_each_possible_rcu_notrace()",
posted earlier today.

Alexey Kardashevskiy (8):
  KVM: PPC: reserve a capability number for multitce support
  KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
  vfio: add external user support
  powerpc: Prepare to support kernel handling of IOMMU map/unmap
  powerpc: add real mode support for dma operations on powernv
  KVM: PPC: Add support for multiple-TCE hcalls
  KVM: PPC: Add support for IOMMU in-kernel handling
  KVM: PPC: Add hugepage support for IOMMU in-kernel handling

 Documentation/virtual/kvm/api.txt         |  51 +++
 arch/powerpc/include/asm/iommu.h          |   9 +-
 arch/powerpc/include/asm/kvm_host.h       |  37 ++
 arch/powerpc/include/asm/kvm_ppc.h        |  18 +-
 arch/powerpc/include/asm/machdep.h        |  12 +
 arch/powerpc/include/asm/pgtable-ppc64.h  |   4 +
 arch/powerpc/include/uapi/asm/kvm.h       |   7 +
 arch/powerpc/kernel/iommu.c               | 200 +++++++----
 arch/powerpc/kvm/book3s_64_vio.c          | 541 +++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 404 ++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c              |  41 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |   6 +
 arch/powerpc/kvm/book3s_pr_papr.c         |  37 +-
 arch/powerpc/kvm/powerpc.c                |  15 +
 arch/powerpc/mm/init_64.c                 |  78 ++++-
 arch/powerpc/platforms/powernv/pci-ioda.c |  26 +-
 arch/powerpc/platforms/powernv/pci.c      |  38 ++-
 arch/powerpc/platforms/powernv/pci.h      |   2 +-
 drivers/vfio/vfio.c                       |  35 ++
 include/linux/page-flags.h                |   4 +-
 include/linux/vfio.h                      |   7 +
 include/uapi/linux/kvm.h                  |   3 +
 22 files changed, 1453 insertions(+), 122 deletions(-)

-- 
1.8.3.2


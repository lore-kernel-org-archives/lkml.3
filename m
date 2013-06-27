Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3F0FC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:02:57 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50885 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3F0FCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:02:54 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/8 v4] KVM: PPC: IOMMU in-kernel handling
Date: Thu, 27 Jun 2013 15:02:28 +1000
Message-Id: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes are:
1. rebased on v3.10-rc7
2. removed spinlocks from real mode
3. added security checks between KVM and VFIO

MOre details in the individual patch comments.


Alexey Kardashevskiy (8):
  KVM: PPC: reserve a capability number for multitce support
  KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
  vfio: add external user support
  hashtable: add hash_for_each_possible_rcu_notrace()
  powerpc: Prepare to support kernel handling of IOMMU map/unmap
  KVM: PPC: Add support for multiple-TCE hcalls
  KVM: PPC: Add support for IOMMU in-kernel handling
  KVM: PPC: Add hugepage support for IOMMU in-kernel handling

 Documentation/virtual/kvm/api.txt        |   51 +++
 arch/powerpc/include/asm/kvm_host.h      |   31 ++
 arch/powerpc/include/asm/kvm_ppc.h       |   18 +-
 arch/powerpc/include/asm/pgtable-ppc64.h |    4 +
 arch/powerpc/include/uapi/asm/kvm.h      |    8 +
 arch/powerpc/kvm/book3s_64_vio.c         |  506 +++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c      |  439 ++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c             |   41 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |    6 +
 arch/powerpc/kvm/book3s_pr_papr.c        |   37 ++-
 arch/powerpc/kvm/powerpc.c               |   15 +
 arch/powerpc/mm/init_64.c                |   78 ++++-
 drivers/vfio/vfio.c                      |   53 ++++
 include/linux/hashtable.h                |   15 +
 include/linux/page-flags.h               |    4 +-
 include/uapi/linux/kvm.h                 |    3 +
 16 files changed, 1279 insertions(+), 30 deletions(-)

-- 
1.7.10.4


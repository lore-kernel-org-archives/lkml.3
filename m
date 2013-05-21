Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3EUDHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:07:08 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45846 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUDHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:07:06 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/4 v2] KVM: PPC: IOMMU in-kernel handling
Date: Tue, 21 May 2013 13:06:43 +1000
Message-Id: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This accelerates IOMMU operations in real and virtual
mode in the host kernel for the KVM guest.

The first patch with multitce support is useful for emulated devices as is.

The other patches are designed for VFIO although this series
does not contain any VFIO related code as the connection between
VFIO and the new handlers is to be made in QEMU
via ioctl to the KVM fd.

The series was made and tested against v3.10-rc1.


Alexey Kardashevskiy (4):
  KVM: PPC: Add support for multiple-TCE hcalls
  powerpc: Prepare to support kernel handling of IOMMU map/unmap
  KVM: PPC: Add support for IOMMU in-kernel handling
  KVM: PPC: Add hugepage support for IOMMU in-kernel handling

 Documentation/virtual/kvm/api.txt        |   42 +++
 arch/powerpc/include/asm/kvm_host.h      |    7 +
 arch/powerpc/include/asm/kvm_ppc.h       |   40 ++-
 arch/powerpc/include/asm/pgtable-ppc64.h |    4 +
 arch/powerpc/include/uapi/asm/kvm.h      |    7 +
 arch/powerpc/kvm/book3s_64_vio.c         |  398 ++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c      |  471 ++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c             |   39 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |    6 +
 arch/powerpc/kvm/book3s_pr_papr.c        |   37 ++-
 arch/powerpc/kvm/powerpc.c               |   15 +
 arch/powerpc/mm/init_64.c                |   77 ++++-
 include/uapi/linux/kvm.h                 |    5 +
 13 files changed, 1120 insertions(+), 28 deletions(-)

-- 
1.7.10.4


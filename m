Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3BKMNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:13:08 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34812 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3BKMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:13:06 -0500
From: aik@ozlabs.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 0/4] powerpc iommu: extending real mode support
Date: Mon, 11 Feb 2013 23:12:39 +1100
Message-Id: <5118e050.22ca320a.1f08.ffffe2e1@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The first 2 patches in this set add a multi-tce support feature
(adding/deleting several TCE records at once) in real and virtual mode.

The last 2 patches enable real mode acceleration for VFIO and
extend the multi-tce feature to be available for VFIO devices.

The QEMU change is required in order to support this functionality
(additional ioctl to add a new LIOBN and hook it with a specific IOMMU)).


Alexey Kardashevskiy (4):
  powerpc: lookup_linux_pte has been made public
  powerpc kvm: added multiple TCEs requests support
  powerpc: preparing to support real mode optimization
  vfio powerpc: added real mode support

 arch/powerpc/include/asm/iommu.h         |   10 +
 arch/powerpc/include/asm/kvm_host.h      |    2 +
 arch/powerpc/include/asm/kvm_ppc.h       |   17 ++
 arch/powerpc/include/asm/pgtable-ppc64.h |    6 +
 arch/powerpc/include/uapi/asm/kvm.h      |    8 +
 arch/powerpc/kernel/iommu.c              |  253 ++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_vio.c         |   55 ++++-
 arch/powerpc/kvm/book3s_64_vio_hv.c      |  397 ++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.c             |   23 ++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |    4 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |    6 +
 arch/powerpc/kvm/book3s_pr_papr.c        |   37 ++-
 arch/powerpc/kvm/powerpc.c               |   14 ++
 arch/powerpc/mm/init_64.c                |   56 ++++-
 include/uapi/linux/kvm.h                 |    2 +
 15 files changed, 852 insertions(+), 38 deletions(-)

-- 
1.7.10.4


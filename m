Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3FEGL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:11:26 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44451 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3FEGLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:11:24 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/4 v3] KVM: PPC: IOMMU in-kernel handling
Date: Wed,  5 Jun 2013 16:11:09 +1000
Message-Id: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, ping! :)

This series has tiny fixes (capability and ioctl numbers,
changed documentation, compile errors in some configuration).
More details are in the commit messages.
Rebased on v3.10-rc4.


Alexey Kardashevskiy (4):
  KVM: PPC: Add support for multiple-TCE hcalls
  powerpc: Prepare to support kernel handling of IOMMU map/unmap
  KVM: PPC: Add support for IOMMU in-kernel handling
  KVM: PPC: Add hugepage support for IOMMU in-kernel handling

 Documentation/virtual/kvm/api.txt        |   45 +++
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
 include/uapi/linux/kvm.h                 |    3 +
 13 files changed, 1121 insertions(+), 28 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaEPP2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:28:44 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48468 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaEPP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:28:41 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@kernel.org
Subject: [GIT PULL] KVM fixes for 3.15-rc6
Date: Fri, 16 May 2014 17:28:32 +0200
Message-Id: <1400254112-4662-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a4e91d04b86504f145cc5f766c2609357a68b186:

  Merge tag 'kvm-s390-for-3.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2014-05-15 14:46:57 +0200)

----------------------------------------------------------------

Small fixes for x86, slightly larger fixes for PPC, and a forgotten s390 patch.
The PPC fixes are important because they fix breakage that is new in 3.15.

----------------------------------------------------------------
Alexander Graf (2):
      KVM: PPC: Book3S: ifdef on CONFIG_KVM_BOOK3S_32_HANDLER for 32bit
      KVM guest: Make pv trampoline code executable

Cornelia Huck (1):
      KVM: s390: announce irqfd capability

Marcelo Tosatti (1):
      KVM: x86: disable master clock if TSC is reset during suspend

Paolo Bonzini (3):
      KVM: vmx: disable APIC virtualization in nested guests
      Merge tag 'signed-for-3.15' of git://github.com/agraf/linux-2.6 into kvm-master
      Merge tag 'kvm-s390-for-3.15-1' of git://git.kernel.org/.../kvms390/linux into kvm-master

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Add missing code for transaction reclaim on guest exit

pingfank@linux.vnet.ibm.com (1):
      KVM: PPC: Book3S: HV: make _PAGE_NUMA take effect

 Documentation/virtual/kvm/api.txt       |   2 +-
 arch/powerpc/include/asm/sections.h     |  11 ++++
 arch/powerpc/kernel/kvm.c               |   2 +-
 arch/powerpc/kvm/book3s.c               |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c     |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 104 ++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_pr.c            |   6 +-
 arch/powerpc/mm/hash_utils_64.c         |   4 ++
 arch/s390/kvm/kvm-s390.c                |   1 +
 arch/x86/kvm/vmx.c                      |   7 ++-
 arch/x86/kvm/x86.c                      |   6 +-
 11 files changed, 139 insertions(+), 12 deletions(-)

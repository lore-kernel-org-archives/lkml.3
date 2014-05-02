Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaEBOJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:09:52 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48312 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:09:50 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.15-rc4
Date: Fri,  2 May 2014 16:09:37 +0200
Message-Id: <1399039777-25382-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 0f689a33ad17845363acdc6d52783befd6ad116c:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2014-04-16 11:28:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a5a5aef451430dbd48f5bf32029b8b98b690074d:

  Merge tag 'kvm-arm-for-3.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2014-04-30 21:25:09 +0200)

----------------------------------------------------------------

- Fix for a Haswell regression in nested virtualization, introduced during
the merge window.

- A fix from Oleg to async page faults.

- A bunch of small ARM changes.

- A trivial patch to use the new MSI-X API introduced during the merge
window.

----------------------------------------------------------------
Alexander Gordeev (1):
      kvm: Use pci_enable_msix_exact() instead of pci_enable_msix()

Andre Przywara (1):
      KVM: arm/arm64: vgic: fix GICD_ICFGR register accesses

Bandan Das (1):
      KVM: x86: Check for host supported fields in shadow vmcs

Haibin Wang (2):
      KVM: ARM: vgic: Fix sgi dispatch problem
      KVM: ARM: vgic: Fix the overlap check action about setting the GICD & GICC base address.

Marc Zyngier (1):
      MAINTAINERS: co-maintainance of KVM/{arm,arm64}

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Paolo Bonzini (1):
      Merge tag 'kvm-arm-for-3.15-rc4' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

Will Deacon (1):
      ARM: KVM: disable KVM in Kconfig on big-endian systems

 MAINTAINERS             |  5 +++++
 arch/arm/kvm/Kconfig    |  2 +-
 arch/arm/kvm/mmu.c      | 15 ++++++++------
 arch/x86/kvm/vmx.c      | 53 ++++++++++++++++++++++++++++++++++++++-----------
 virt/kvm/arm/vgic.c     | 15 +++++++-------
 virt/kvm/assigned-dev.c |  3 ++-
 virt/kvm/async_pf.c     |  8 ++++----
 7 files changed, 70 insertions(+), 31 deletions(-)

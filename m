Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaIEKQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:16:49 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45056 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbaIEKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:16:47 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.17-rc4
Date: Fri,  5 Sep 2014 12:16:26 +0200
Message-Id: <1409912186-22968-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 30d1e0e806e5b2fadc297ba78f2d7afd6ba309cf:

  virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1' after free it (2014-08-19 15:12:28 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b11ba8c62be3eba54784611c769f4d7d07fac4a5:

  KVM: x86: fix kvmclock breakage from timers branch merge (2014-09-04 23:42:11 +0200)

----------------------------------------------------------------
A smattering of bug fixes across most architectures.

The x86 fix is really working around a timekeeping bug that is being
exposed by KVM.  Thomas and John are aware of it and they are working
on the real fix.  I am including the workaround because I think it
makes the code nicer, so I would submit it sooner or later anyway.

----------------------------------------------------------------
Christian Borntraeger (4):
      KVM: s390: Fix user triggerable bug in dead code
      KVM: s390/mm: try a cow on read only pages for key ops
      KVM: s390/mm: Fix storage key corruption during swapping
      KVM: s390/mm: Fix guest storage key corruption in ptep_set_access_flags

Christoffer Dall (1):
      arm/arm64: KVM: Complete WFI/WFE instructions

Laurent Dufour (1):
      powerpc/kvm/cma: Fix panic introduces by signed shift operation

Paolo Bonzini (4):
      Merge tag 'kvm-s390-20140825' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge tag 'kvm-arm-for-v3.17-rc3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-20140902' of git://git.kernel.org/.../kvms390/linux into kvm-master
      KVM: x86: fix kvmclock breakage from timers branch merge

Pranavkumar Sawargaonkar (1):
      ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

 arch/arm/kvm/handle_exit.c          |  2 ++
 arch/arm/kvm/init.S                 |  4 ++++
 arch/arm64/kvm/handle_exit.c        |  2 ++
 arch/arm64/kvm/hyp-init.S           |  4 ++++
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  4 ++--
 arch/s390/include/asm/pgtable.h     |  6 ++++--
 arch/s390/kvm/kvm-s390.c            | 13 -------------
 arch/s390/mm/pgtable.c              | 10 ++++++++++
 arch/x86/kvm/x86.c                  | 13 +++++++------
 9 files changed, 35 insertions(+), 23 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3LTSUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:20:10 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41923 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3LTSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:20:08 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: kvm@vger.kernel.org, gleb@kernel.org, agraf@suse.de
Subject: [GIT PULL] KVM changes for 3.13-rc5
Date: Fri, 20 Dec 2013 19:19:51 +0100
Message-Id: <1387563591-2137-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 5e6d26cf4857a98032a4b71b13d5b33163803523:

  Merge tag 'signed-for-3.13' of git://github.com/agraf/linux-2.6 into kvm-master (2013-12-20 19:13:58 +0100)

----------------------------------------------------------------

The PPC folks had a large amount of changes queued for 3.13, and now they
are fixing the bugs.

----------------------------------------------------------------
Alexander Graf (4):
      KVM: PPC: Book3S: PR: Don't clobber our exit handler id
      KVM: PPC: Book3S: PR: Export kvmppc_copy_to|from_svcpu
      KVM: PPC: Book3S: PR: Make svcpu -> vcpu store preempt savvy
      KVM: PPC: Book3S: PR: Enable interrupts earlier

Aneesh Kumar K.V (1):
      powerpc: book3s: kvm: Don't abuse host r2 in exit path

Paolo Bonzini (1):
      Merge tag 'signed-for-3.13' of git://github.com/agraf/linux-2.6 into kvm-master

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Fix physical address calculations
      KVM: PPC: Book3S HV: Refine barriers in guest entry/exit
      KVM: PPC: Book3S HV: Make tbacct_lock irq-safe
      KVM: PPC: Book3S HV: Take SRCU read lock around kvm_read_guest() call
      KVM: PPC: Book3S HV: Don't drop low-order page address bits

Scott Wood (1):
      powerpc/kvm/booke: Fix build break due to stack frame size warning

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene

 arch/powerpc/include/asm/kvm_book3s.h     |  4 ++++
 arch/powerpc/include/asm/kvm_book3s_asm.h |  2 ++
 arch/powerpc/include/asm/switch_to.h      |  2 +-
 arch/powerpc/kernel/asm-offsets.c         |  1 +
 arch/powerpc/kernel/process.c             | 32 +++++++++++++++----------------
 arch/powerpc/kvm/book3s_64_mmu_hv.c       | 18 +++++++++++++----
 arch/powerpc/kvm/book3s_hv.c              | 24 +++++++++++++----------
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |  9 +++++++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 23 ++++++++++++----------
 arch/powerpc/kvm/book3s_interrupts.S      | 19 ++++++++++--------
 arch/powerpc/kvm/book3s_pr.c              | 22 +++++++++++++++++++++
 arch/powerpc/kvm/book3s_rmhandlers.S      |  6 +-----
 arch/powerpc/kvm/booke.c                  | 12 ++++++------
 13 files changed, 112 insertions(+), 62 deletions(-)

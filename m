Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3HSUyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:54:55 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44720 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3HSUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:54:53 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 3.11-rc7
Date: Mon, 19 Aug 2013 22:54:44 +0200
Message-Id: <1376945684-15950-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

the following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c566ccfcb30e236636085317a05cb3e8808e7f4a:

  Merge tag 'kvm-arm-fixes-3.11' of git://git.linaro.org/people/cdall/linux-kvm-arm into kvm-master (2013-08-12 09:44:16 +0200)

This pull request is coming a bit later than I would have preferred,
because I and Gleb happened to have holidays around the same weeks
of August...  sorry about that.

Paolo
----------------------------------------------------------------

Fixes for ARM and aarch64.

----------------------------------------------------------------
Chen Gang (1):
      arm64: KVM: use 'int' instead of 'u32' for variable 'target' in kvm_host.h.

Christoffer Dall (3):
      ARM: KVM: Fix 64-bit coprocessor handling
      ARM: KVM: Fix unaligned unmap_range leak
      KVM: ARM: Squash len warning

Marc Zyngier (3):
      arm64: KVM: fix 2-level page tables unmapping
      arm64: KVM: perform save/restore of PAR_EL1
      arm64: KVM: add missing dsb before invalidating Stage-2 TLBs

Paolo Bonzini (2):
      Merge branch 'kvm-arm64/fixes-3.11-rc4' of git://git.kernel.org/.../maz/arm-platforms into kvm-master
      Merge tag 'kvm-arm-fixes-3.11' of git://git.linaro.org/people/cdall/linux-kvm-arm into kvm-master

 arch/arm/kvm/coproc.c             | 26 +++++++++++++++++++-------
 arch/arm/kvm/coproc.h             |  3 +++
 arch/arm/kvm/coproc_a15.c         |  6 +++++-
 arch/arm/kvm/mmio.c               |  3 ++-
 arch/arm/kvm/mmu.c                | 36 +++++++++++++++---------------------
 arch/arm64/include/asm/kvm_asm.h  | 17 ++++++++++-------
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/hyp.S              | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c         |  3 +++
 9 files changed, 71 insertions(+), 38 deletions(-)

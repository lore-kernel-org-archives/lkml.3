Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaGULYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:24:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41693 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaGULYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:24:18 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.16-rc7
Date: Mon, 21 Jul 2014 13:24:05 +0200
Message-Id: <1405941845-2052-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to bb18b526a9d8d4a3fe56f234d5013b9f6036978d:

  Merge tag 'signed-for-3.16' of git://github.com/agraf/linux-2.6 into kvm-master (2014-07-08 12:08:58 +0200)

----------------------------------------------------------------

These are mostly PPC changes for 3.16-new things.  However, there is
an x86 change too and it is a regression from 3.14.  As it only affects
nested virtualization and there were other changes in this area in 3.16,
I am not nominating it for 3.15-stable.

----------------------------------------------------------------
Alexander Graf (3):
      PPC: Add _GLOBAL_TOC for 32bit
      KVM: PPC: Book3S PR: Fix ABIv2 on LE
      KVM: PPC: RTAS: Do byte swaps explicitly

Aneesh Kumar K.V (1):
      KVM: PPC: BOOK3S: HV: Use base page size when comparing against slb value

Anton Blanchard (1):
      KVM: PPC: Assembly functions exported to modules need _GLOBAL_TOC()

Bandan Das (1):
      KVM: x86: Check for nested events if there is an injectable interrupt

Mihai Caraman (1):
      KVM: PPC: Book3E: Unlock mmu_lock when setting caching atttribute

Paolo Bonzini (1):
      Merge tag 'signed-for-3.16' of git://github.com/agraf/linux-2.6 into kvm-master

 arch/powerpc/include/asm/kvm_book3s_64.h | 19 +++++++++-
 arch/powerpc/include/asm/ppc_asm.h       |  2 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  7 +---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  2 +-
 arch/powerpc/kvm/book3s_interrupts.S     |  4 ++
 arch/powerpc/kvm/book3s_rmhandlers.S     |  6 ++-
 arch/powerpc/kvm/book3s_rtas.c           | 65 +++++++++-----------------------
 arch/powerpc/kvm/e500_mmu_host.c         |  3 +-
 arch/x86/kvm/x86.c                       | 12 ++++++
 10 files changed, 64 insertions(+), 58 deletions(-)

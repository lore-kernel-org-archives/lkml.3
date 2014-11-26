Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaKZNvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:51:43 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41258 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKZNvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:51:42 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.18-rc7 (or final)
Date: Wed, 26 Nov 2014 14:51:34 +0100
Message-Id: <1417009894-31956-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b914c5b2130239fd378d1a719ab3c53f0c782be9:

  Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux (2014-11-25 19:05:41 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d3fccc7ef831d1d829b4da5eaa081db55b1e38f3:

  kvm: fix kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn() (2014-11-26 14:40:45 +0100)

----------------------------------------------------------------
Last minute KVM/ARM fixes; even the generic change actually
affects nothing but ARM.

----------------------------------------------------------------
Ard Biesheuvel (2):
      arm/arm64: kvm: drop inappropriate use of kvm_is_mmio_pfn()
      kvm: fix kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()

Christoffer Dall (2):
      arm64: KVM: Handle traps of ICC_SRE_EL1 as RAZ/WI
      arm/arm64: KVM: vgic: Fix error code in kvm_vgic_create()

Mark Rutland (1):
      arm64: KVM: fix unmapping with 48-bit VAs

 arch/arm/kvm/mmu.c        | 10 ++++++++--
 arch/arm64/kvm/sys_regs.c |  9 +++++++++
 arch/ia64/kvm/kvm-ia64.c  |  2 +-
 arch/x86/kvm/mmu.c        |  6 +++---
 include/linux/kvm_host.h  |  2 +-
 virt/kvm/arm/vgic.c       |  8 ++++----
 virt/kvm/kvm_main.c       | 16 ++++++++--------
 7 files changed, 34 insertions(+), 19 deletions(-)

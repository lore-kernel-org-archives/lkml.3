Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3FDM2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3FDM2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:28:13 -0400
Date: Tue, 4 Jun 2013 15:28:09 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.10-rc4
Message-ID: <20130604122809.GA8416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git fixes

To receive KVM bug fixes. The bulk of the fixes is in MIPS KVM
kernel<->userspace ABI. MIPS KVM is new for 3.10 and some problems were
found with current ABI. It is better to fix them now and do not have
a kernel with broken one.


Andre Przywara (1):
      ARM: KVM: prevent NULL pointer dereferences with KVM VCPU ioctl

David Daney (6):
      mips/kvm: Fix ABI for use of FPU.
      mips/kvm: Fix ABI for use of 64-bit registers.
      mips/kvm: Fix name of gpr field in struct kvm_regs.
      mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in kvm_arch_vcpu_ioctl_{s,g}et_regs
      mips/kvm: Fix ABI by moving manipulation of CP0 registers to KVM_{G,S}ET_ONE_REG
      mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.

Gleb Natapov (1):
      KVM: Fix race in apic->pending_events processing

Marc Zyngier (1):
      ARM: KVM: be more thorough when invalidating TLBs

Paolo Bonzini (2):
      KVM: Emulate multibyte NOP
      KVM: fix sil/dil/bpl/spl in the mod/rm fields

 arch/arm/kvm/arm.c               |   15 +-
 arch/arm/kvm/mmu.c               |   41 ++++--
 arch/mips/include/asm/kvm_host.h |    4 -
 arch/mips/include/uapi/asm/kvm.h |  137 +++++++++++++++----
 arch/mips/kvm/kvm_mips.c         |  280 +++++++++++++++++++++++++++++++++++---
 arch/mips/kvm/kvm_trap_emul.c    |   50 -------
 arch/x86/kvm/emulate.c           |    9 +-
 arch/x86/kvm/lapic.c             |    9 +-
 8 files changed, 421 insertions(+), 124 deletions(-)

--
			Gleb.

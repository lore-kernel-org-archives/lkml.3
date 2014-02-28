Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaB1QTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:19:01 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49910 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaB1QTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:19:00 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.14-rc5
Date: Fri, 28 Feb 2014 17:18:50 +0100
Message-Id: <1393604330-17086-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1b385cbdd74aa803e966e01e5fe49490d6044e30:

  kvm, vmx: Really fix lazy FPU on nested guest (2014-02-27 22:54:11 +0100)

Thanks,

Paolo

----------------------------------------------------------------
Three x86 fixes and one for ARM/ARM64.  In particular, nested
virtualization on Intel is broken in 3.13 and fixed by this
pull request.

----------------------------------------------------------------
Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Marc Zyngier (1):
      arm/arm64: KVM: detect CPU reset on CPU_PM_EXIT

Marcelo Tosatti (1):
      KVM: MMU: drop read-only large sptes when creating lower level sptes

Paolo Bonzini (1):
      kvm, vmx: Really fix lazy FPU on nested guest

 arch/arm/kvm/arm.c        |  3 ++-
 arch/arm/kvm/interrupts.S | 11 ++++++++++-
 arch/arm64/kvm/hyp.S      | 27 +++++++++++++++++++++++++--
 arch/x86/kvm/mmu.c        |  1 +
 arch/x86/kvm/vmx.c        |  2 +-
 arch/x86/kvm/x86.c        |  2 +-
 6 files changed, 40 insertions(+), 6 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaKBJIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 04:08:30 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42219 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaKBJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 04:08:24 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 3.18-rc3 or -rc4
Date: Sun,  2 Nov 2014 10:08:12 +0100
Message-Id: <1414919292-5890-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a73896cb5bbdce672945745db8224352a689f580:

  KVM: vmx: defer load of APIC access page address during reset (2014-11-02 08:37:18 +0100)

A bit late---needed some time to test the SRCU fix, which only came in
on Friday.  I'm not going to complain if this misses -rc3!

Thanks,

Paolo

----------------------------------------------------------------
A small set of x86 fixes.  The most serious is an SRCU lockdep fix.

----------------------------------------------------------------
Jan Kiszka (1):
      KVM: nVMX: Disable preemption while reading from shadow VMCS

Nadav Amit (1):
      KVM: x86: Fix far-jump to non-canonical check

Paolo Bonzini (3):
      KVM: emulator: fix error code for __linearize
      KVM: emulator: fix execution close to the segment limit
      KVM: vmx: defer load of APIC access page address during reset

 arch/x86/kvm/emulate.c | 55 ++++++++++++++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx.c     |  6 +++++-
 2 files changed, 45 insertions(+), 16 deletions(-)

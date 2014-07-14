Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaGNLjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:39:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47279 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaGNLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:38:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH resend 00/19] Emulator speedups for 3.17
Date: Mon, 14 Jul 2014 13:38:24 +0200
Message-Id: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the emulator speedup patches that have survived autotest
and kvm-unit-tests.  I dropped the patches for direct access to
memory operands because they caused a failure in vmx.flat.

These patches have been in kvm/queue for a while, but I've always
left them out of kvm/next because they hadn't undergone full review.
Since three months have passed, I'll include them in the next push to
kvm/next to give them more exposure and to prepare for 3.17.

Paolo

Bandan Das (6):
  KVM: emulate: move init_decode_cache to emulate.c
  KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
  KVM: emulate: cleanup decode_modrm
  KVM: emulate: clean up initializations in init_decode_cache
  KVM: emulate: rework seg_override
  KVM: emulate: do not initialize memopp

Paolo Bonzini (13):
  KVM: vmx: speed up emulation of invalid guest state
  KVM: x86: return all bits from get_interrupt_shadow
  KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
  KVM: emulate: move around some checks
  KVM: emulate: protect checks on ctxt->d by a common "if (unlikely())"
  KVM: emulate: speed up emulated moves
  KVM: emulate: simplify writeback
  KVM: emulate: speed up do_insn_fetch
  KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
  KVM: emulate: avoid per-byte copying in instruction fetches
  KVM: emulate: put pointers in the fetch_cache
  KVM: x86: ensure emulator fetches do not span multiple pages
  KVM: x86: use kvm_read_guest_page for emulator accesses

 arch/x86/include/asm/kvm_emulate.h |  31 +--
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/emulate.c             | 379 +++++++++++++++++++------------------
 arch/x86/kvm/svm.c                 |   6 +-
 arch/x86/kvm/trace.h               |   6 +-
 arch/x86/kvm/vmx.c                 |   9 +-
 arch/x86/kvm/x86.c                 |  80 +++++---
 7 files changed, 277 insertions(+), 236 deletions(-)

-- 
1.8.3.1


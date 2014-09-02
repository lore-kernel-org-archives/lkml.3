Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaIBPN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:13:59 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46361 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaIBPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:13:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jroedel@suse.de, agraf@suse.de, valentine.sinitsyn@gmail.com,
        jan.kiszka@siemens.com, gleb@cloudius-systems.com,
        avi@cloudius-systems.com
Subject: [PATCH 0/4] KVM: nested x86: nested page faults fixes
Date: Tue,  2 Sep 2014 17:13:46 +0200
Message-Id: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 implements AMD semantics for non-leaf PDPEs and PML4Es, which
are a bit different from Intel.  The SVM test relies on this, so fix it.

Patch 2 lets nested SVM implement nested page fault correctly.  We were
not setting bits 32/33.

Patches 3 and 4 fix the interaction between emulator and nested EPT/NPT,
which was reported by Valentine.

Reviews are very welcome, I'm walking on thin ice here...

Paolo

Paolo Bonzini (4):
  KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD
  KVM: nSVM: propagate the NPF EXITINFO to the guest
  KVM: x86: inject nested page faults on emulated instructions
  KVM: x86: propagate exception from permission checks on the nested page fault

 arch/x86/include/asm/kvm_host.h |  9 ++++++---
 arch/x86/kvm/cpuid.h            |  8 ++++++++
 arch/x86/kvm/mmu.c              | 15 ++++++++++++---
 arch/x86/kvm/paging_tmpl.h      | 13 ++++++++++---
 arch/x86/kvm/svm.c              | 26 ++++++++++++++++++++++----
 arch/x86/kvm/x86.c              | 27 +++++++++++++++++++--------
 6 files changed, 77 insertions(+), 21 deletions(-)

-- 
1.8.3.1


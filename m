Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaDAP0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:26:54 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62344 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaDAP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:26:52 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 0/6] KVM: x86: speedups for emulator memory accesses
Date: Tue,  1 Apr 2014 17:26:40 +0200
Message-Id: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another emulator speedup series, shaving up to 400 cycles (25%) off
RMW instructions.

The performance of various instructions is now relatively flat:

 jump  919  (down from 2300)
 move  1075 (down from 2700)
 arith 1081 (down from 2600)
 load  1267 (down from 2800, 1400 after previous round)
 store 1213 (down from 2900, 1300 after previous round)
 RMW   1310 (down from 3200, 1700 after previous round)

The next low-hanging fruit is fetching instructions and initializing
the context.  Similar optimizations to those done here could be made
for instruction fetch.

Paolo Bonzini (6):
  KVM: emulate: simplify writeback
  KVM: emulate: abstract handling of memory operands
  KVM: export mark_page_dirty_in_slot
  KVM: emulate: introduce memory_prepare callback to speed up memory access
  KVM: emulate: activate memory access optimization
  KVM: emulate: extend memory access optimization to stores

 arch/x86/include/asm/kvm_emulate.h |  28 ++++++++++
 arch/x86/kvm/emulate.c             | 107 +++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c                 |  67 +++++++++++++++++++++++
 include/linux/kvm_host.h           |   6 +++
 virt/kvm/kvm_main.c                |  17 ++----
 5 files changed, 185 insertions(+), 40 deletions(-)

-- 
1.8.3.1


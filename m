Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaGULiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:38:54 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48127 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754157AbaGULix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:38:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZyVGHVIEbFg8BAQEnPYUDihO4KIZMF49LHYQwBYpfqDw
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZyVGHVIEbFg8BAQEnPYUDihO4KIZMF49LHYQwBYpfqDw
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353321"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/7] KVM: x86: Additional rflags.rf fixes
Date: Mon, 21 Jul 2014 14:37:23 +0300
Message-Id: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFLAGS.RF is not handled well by kvm, in both the x86 emulator and vmx code.
This flag should be cleared after every instruction emulation (other than
IRETD/IRETQ).  It should be set in various conditions as described in Intel SDM
17.3.1.1.  This series of patches addresses the clearing of RF on emulated
instructions, the setting the RF upon fault injection.  It does not handle the
case of traps and interrupts injection during REP-string, since there is
no easy indication whether the first iteration of a rep-string occurred.
The value of RF depends on whether the first iteration took place.

Thanks for reviewing the patches.

Nadav Amit (7):
  KVM: x86: Defining missing x86 vectors
  KVM: x86: Function for determining exception type
  KVM: x86: Clearing rflags.rf upon skipped emulated instruction
  KVM: vmx: set rflags.rf during fault injection
  KVM: x86: popf emulation should not change RF
  KVM: x86: Clear rflags.rf on emulated instructions
  KVM: x86: Cleanup of rflags.rf cleaning

 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/emulate.c          | 13 ++++++++-----
 arch/x86/kvm/vmx.c              | 11 ++++++++++-
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  9 +++++++++
 5 files changed, 67 insertions(+), 6 deletions(-)

-- 
1.9.1


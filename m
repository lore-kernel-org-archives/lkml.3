Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529AbaFROTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:38610 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaFROTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRV4hbxxuFXheFYokTBxaELQSKOacn
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRV4hbxxuFXheFYokTBxaELQSKOacn
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034531"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 0/9] KVM: x86: More emulator bugs
Date: Wed, 18 Jun 2014 17:19:17 +0300
Message-Id: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <539F059F.8050501@redhat.com>
References: <539F059F.8050501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set resolves several emulator bugs. Each fix is independent of the
others.  The DR6 bug can occur during DR-access exit (regardless to 
unrestricted mode, MMIO and SPT).


Changes in v2:

Introduced kvm_register_readl and kvm_register_writel which consider long-mode
and cs.l when reading the registers.

Fixing the register read to respect 32/64 bit in hypercall handling, CR exit
handling and VMX instructions handling.

Thanks for re-reviewing the patch

Nadav Amit (9):
  KVM: x86: bit-ops emulation ignores offset on 64-bit
  KVM: x86: Wrong emulation on 'xadd X, X'
  KVM: x86: Inter privilage level ret emulation is not implemeneted
  KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
  KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
  KVM: x86: check DR6/7 high-bits are clear only on long-mode
  KVM: x86: Hypercall handling does not considers opsize correctly
  KVM: vmx: handle_cr ignores 32/64-bit mode
  KVM: vmx: vmx instructions handling does not consider cs.l

 arch/x86/kvm/emulate.c | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/vmx.c     | 16 ++++++++--------
 arch/x86/kvm/x86.c     | 11 ++++++-----
 arch/x86/kvm/x86.h     | 27 +++++++++++++++++++++++++++
 4 files changed, 61 insertions(+), 24 deletions(-)

-- 
1.9.1


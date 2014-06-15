Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFONPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:15:06 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:22664 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaFONNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:13:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsCAPuanVOERCABjGdsb2JhbABariIBAQaDXo4Eh0KBARYPAQEBJzyFA4oTyViFJheFY4kTHYQtBIo5pyU
X-IPAS-Result: AgsCAPuanVOERCABjGdsb2JhbABariIBAQaDXo4Eh0KBARYPAQEBJzyFA4oTyViFJheFY4kTHYQtBIo5pyU
X-IronPort-AV: E=Sophos;i="5.01,481,1400014800"; 
   d="scan'208";a="111523997"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/6] KVM: x86: More emulator bugs
Date: Sun, 15 Jun 2014 16:12:56 +0300
Message-Id: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set resolves several emulator bugs. Each fix is independent of the
others.  The DR6/7 bug can occur during DR-access exit (regardless to
unrestricted mode, MMIO and SPT).

Thanks for reviewing the patches,
Nadav

Nadav Amit (6):
  KVM: x86: bit-ops emulation ignores offset on 64-bit
  KVM: x86: Wrong emulation on 'xadd X, X'
  KVM: x86: Inter privilage level ret emulation is not implemeneted
  KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
  KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
  KVM: x86: check DR6/7 high-bits are clear only on long-mode

 arch/x86/kvm/emulate.c | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/x86.c     | 13 +++++++++++--
 2 files changed, 31 insertions(+), 13 deletions(-)

-- 
1.9.1


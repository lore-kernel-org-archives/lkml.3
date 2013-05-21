Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3EUUzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:55:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51541 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3EUUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:55:03 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v4 0/6] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Date: Tue, 21 May 2013 13:54:49 -0700
Message-Id: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The initial patch set implementing MIPS KVM does not handle 64-bit
guests or use of the FPU.  This patch set corrects these ABI issues,
and does some very minor clean up.

Chandes from v3: Use KVM_SET_ONE_REG instead of KVM_SET_MSRS.  Added
                 ENOIOCTLCMD patch.

Changes from v2: Split into five parts, no code change.

David Daney (6):
  mips/kvm: Fix ABI for use of FPU.
  mips/kvm: Fix ABI for use of 64-bit registers.
  mips/kvm: Fix name of gpr field in struct kvm_regs.
  mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in
    kvm_arch_vcpu_ioctl_{s,g}et_regs
  mips/kvm: Fix ABI by moving manipulation of CP0 registers to
    KVM_{G,S}ET_ONE_REG
  mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.

 arch/mips/include/asm/kvm.h      | 137 ++++++++++++----
 arch/mips/include/asm/kvm_host.h |   4 -
 arch/mips/kvm/kvm_mips.c         | 118 +++-----------
 arch/mips/kvm/kvm_trap_emul.c    | 338 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 430 insertions(+), 167 deletions(-)

-- 
1.7.11.7


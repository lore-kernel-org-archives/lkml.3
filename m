Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3FZFfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:35:25 -0400
Received: from [207.46.163.26] ([207.46.163.26]:38558 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab3FZFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:35:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz177df4h17326ah8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <tiejun.chen@windriver.com>,
        <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <mikey@neuling.org>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 0/6 v5] KVM :PPC: Userspace Debug support
Date: Wed, 26 Jun 2013 11:12:20 +0530
Message-ID: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharat Bhushan <bharat.bhushan@freescale.com>

Note: These patches are based on http://github.com/agraf/linux-2.6.git queue

This patchset adds the userspace debug support for booke/bookehv.
this is tested on powerpc e500v2/e500mc devices.

We are now assuming that debug resource will not be used by kernel for
its own debugging. It will be used for only kernel user process debugging.
So the kernel debug load interface during context_to is used to load
debug conext for that selected process.

v4->v5
 - Some comments reworded and other cleanup (like change of function name etc)
 - Added a function for setting MSRP rather than inline

v3->v4
 - 4 out of 7 patches of initial patchset were applied.
   This patchset is on and above those 4 patches
 - KVM local "struct kvmppc_booke_debug_reg" is replaced by
   powerpc global "struct debug_reg"
 - use switch_booke_debug_regs() for debug register context switch.
 - Save DBSR before kernel pre-emption is enabled.
 - Some more cleanup

v2->v3
 - We are now assuming that debug resource will not be used by
   kernel for its own debugging.
   It will be used for only kernel user process debugging.
   So the kernel debug load interface during context_to is
   used to load debug conext for that selected process.

v1->v2
 - Debug registers are save/restore in vcpu_put/vcpu_get.
   Earlier the debug registers are saved/restored in guest entry/exit

Bharat Bhushan (6):
  powerpc: remove unnecessary line continuations
  powerpc: move debug registers in a structure
  powerpc: export debug registers save function for KVM
  KVM: PPC: exit to user space on "ehpriv" instruction
  KVM: PPC: Using "struct debug_reg"
  KVM: PPC: Add userspace debug stub support

 arch/powerpc/include/asm/disassemble.h |    4 +
 arch/powerpc/include/asm/kvm_host.h    |   16 +--
 arch/powerpc/include/asm/processor.h   |   38 +++--
 arch/powerpc/include/asm/reg_booke.h   |    8 +-
 arch/powerpc/include/asm/switch_to.h   |    4 +
 arch/powerpc/include/uapi/asm/kvm.h    |   22 ++-
 arch/powerpc/kernel/asm-offsets.c      |    2 +-
 arch/powerpc/kernel/process.c          |   45 +++---
 arch/powerpc/kernel/ptrace.c           |  154 +++++++++---------
 arch/powerpc/kernel/signal_32.c        |    6 +-
 arch/powerpc/kernel/traps.c            |   35 ++--
 arch/powerpc/kvm/booke.c               |  273 ++++++++++++++++++++++++++++----
 arch/powerpc/kvm/booke.h               |    5 +
 arch/powerpc/kvm/e500_emulate.c        |   27 +++
 14 files changed, 455 insertions(+), 184 deletions(-)



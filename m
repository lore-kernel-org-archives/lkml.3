Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3EVTF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:05:57 -0400
Received: from kymasys.com ([64.62.140.43]:37827 "HELO kymasys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753642Ab3EVTFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:05:55 -0400
Subject: Re: [PATCH v5 0/6] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Sanjay Lal <sanjayl@kymasys.com>
In-Reply-To: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
Date: Wed, 22 May 2013 12:05:52 -0700
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1DD81AF9-D720-4A61-8468-1D61558C9BA1@kymasys.com>
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2013, at 11:43 AM, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The initial patch set implementing MIPS KVM does not handle 64-bit
> guests or use of the FPU.  This patch set corrects these ABI issues,
> and does some very minor clean up.
> 
> Changes from v4: No code change, just keep more of the code in
>                 kvm_mips.c rather than kvm_trap_emul.c
> 
> Changes from v3: Use KVM_SET_ONE_REG instead of KVM_SET_MSRS.  Added
>                 ENOIOCTLCMD patch.
> 
> Changes from v2: Split into five parts, no code change.
> 
> David Daney (6):
>  mips/kvm: Fix ABI for use of FPU.
>  mips/kvm: Fix ABI for use of 64-bit registers.
>  mips/kvm: Fix name of gpr field in struct kvm_regs.
>  mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in
>    kvm_arch_vcpu_ioctl_{s,g}et_regs
>  mips/kvm: Fix ABI by moving manipulation of CP0 registers to
>    KVM_{G,S}ET_ONE_REG
>  mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.
> 
> arch/mips/include/asm/kvm.h      | 137 +++++++++++++++----
> arch/mips/include/asm/kvm_host.h |   4 -
> arch/mips/kvm/kvm_mips.c         | 278 ++++++++++++++++++++++++++++++++++++---
> arch/mips/kvm/kvm_trap_emul.c    |  50 -------
> 4 files changed, 367 insertions(+), 102 deletions(-)
> 
> -- 
> 1.7.11.7

Acked-by: Sanjay Lal <sanjayl@kymasys.com>

Regards
Sanjay


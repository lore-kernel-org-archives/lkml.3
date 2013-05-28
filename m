Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab3E1Ll3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:41:29 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:41437 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab3E1Ll1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:41:27 -0400
Message-ID: <51A497DA.50803@redhat.com>
Date: Tue, 28 May 2013 13:41:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v6 0/6] mips/kvm: Fix ABI for compatibility with 64-bit
 guests.
References: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/05/2013 18:49, David Daney ha scritto:
> From: David Daney <david.daney@cavium.com>
> 
> The initial patch set implementing MIPS KVM does not handle 64-bit
> guests or use of the FPU.  This patch set corrects these ABI issues,
> and does some very minor clean up.
> 
> Changes from v5: Adjust for kvm.h moving to uapi/asm.  Code formatting
>                  to achieve line lengths <= 80.
> 
> Changes from v4: No code change, just keep more of the code in
>                  kvm_mips.c rather than kvm_trap_emul.c
> 
> Changes from v3: Use KVM_SET_ONE_REG instead of KVM_SET_MSRS.  Added
>                  ENOIOCTLCMD patch.
> 
> Changes from v2: Split into five parts, no code change.
> 
> David Daney (6):
>   mips/kvm: Fix ABI for use of FPU.
>   mips/kvm: Fix ABI for use of 64-bit registers.
>   mips/kvm: Fix name of gpr field in struct kvm_regs.
>   mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in
>     kvm_arch_vcpu_ioctl_{s,g}et_regs
>   mips/kvm: Fix ABI by moving manipulation of CP0 registers to
>     KVM_{G,S}ET_ONE_REG
>   mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.
> 
>  arch/mips/include/asm/kvm_host.h |   4 -
>  arch/mips/include/uapi/asm/kvm.h | 137 +++++++++++++++----
>  arch/mips/kvm/kvm_mips.c         | 280 ++++++++++++++++++++++++++++++++++++---
>  arch/mips/kvm/kvm_trap_emul.c    |  50 -------
>  4 files changed, 369 insertions(+), 102 deletions(-)
> 

Applied, thanks.

Paolo

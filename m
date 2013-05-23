Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3EWK2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053Ab3EWK2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:28:49 -0400
Date: Thu, 23 May 2013 13:28:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v5 0/6] mips/kvm: Fix ABI for compatibility with 64-bit
 guests.
Message-ID: <20130523102834.GN4725@redhat.com>
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:43:50AM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
Please regenerate against master. arch/mips/include/asm/kvm.h does not
exists any more.

> The initial patch set implementing MIPS KVM does not handle 64-bit
> guests or use of the FPU.  This patch set corrects these ABI issues,
> and does some very minor clean up.
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
>  arch/mips/include/asm/kvm.h      | 137 +++++++++++++++----
>  arch/mips/include/asm/kvm_host.h |   4 -
>  arch/mips/kvm/kvm_mips.c         | 278 ++++++++++++++++++++++++++++++++++++---
>  arch/mips/kvm/kvm_trap_emul.c    |  50 -------
>  4 files changed, 367 insertions(+), 102 deletions(-)
> 
> -- 
> 1.7.11.7

--
			Gleb.

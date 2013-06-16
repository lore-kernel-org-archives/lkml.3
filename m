Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3FPLmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:42:50 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43172 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3FPLms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:42:48 -0400
Date: Sun, 16 Jun 2013 13:42:40 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 27/31] mips/kvm: Gate the use of
 kvm_local_flush_tlb_all() by KVM_MIPSTE
Message-ID: <20130616114240.GJ20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-28-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-28-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:31PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> Only the trap-and-emulate KVM code needs a Special tlb flusher.  All
> other configurations should use the regular version.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/mmu_context.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
> index 5609a32..04d0b74 100644
> --- a/arch/mips/include/asm/mmu_context.h
> +++ b/arch/mips/include/asm/mmu_context.h
> @@ -117,7 +117,7 @@ get_new_asid(unsigned long cpu)
>  	if (! ((asid += ASID_INC) & ASID_MASK) ) {
>  		if (cpu_has_vtag_icache)
>  			flush_icache_all();
> -#ifdef CONFIG_VIRTUALIZATION
> +#if IS_ENABLED(CONFIG_KVM_MIPSTE)
>  		kvm_local_flush_tlb_all();      /* start new asid cycle */
>  #else
>  		local_flush_tlb_all();	/* start new asid cycle */

Sanjay,

it would seem this is actually a bug if KVM is built as a module and should
be fixed for 3.10?

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf

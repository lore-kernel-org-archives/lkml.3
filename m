Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3KGHwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:52:01 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59242 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3KGHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:51:54 -0500
Date: Thu, 7 Nov 2013 08:51:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107075151.GB31560@gmail.com>
References: <20131106191913.GA18661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106191913.GA18661@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> --- a/arch/powerpc/include/asm/uprobes.h
> +++ b/arch/powerpc/include/asm/uprobes.h
> @@ -37,6 +37,7 @@ typedef ppc_opcode_t uprobe_opcode_t;
>  struct arch_uprobe {
>  	union {
>  		u8	insn[MAX_UINSN_BYTES];
> +		u8	ixol[MAX_UINSN_BYTES];
>  		u32	ainsn;
>  	};
>  };

> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
>  
>  struct arch_uprobe {
>  	u16				fixups;
> -	u8				insn[MAX_UINSN_BYTES];
> +	union {
> +		u8			insn[MAX_UINSN_BYTES];
> +		u8			ixol[MAX_UINSN_BYTES];
> +	};
>  #ifdef CONFIG_X86_64
>  	unsigned long			rip_rela_target_address;
>  #endif

Btw., at least on the surface, the powerpc and x86 definitions seem rather 
similar, barring senseless variations. Would it make sense to generalize 
the data structure a bit more?

Also, we all hate data structures that are not self-documenting. What does 
'ixol' mean and what is its role? Is it obvious to the reader of that 
file?

Thanks,

	Ingo

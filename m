Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaFZT4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:56:32 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57871 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFZT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:56:31 -0400
Date: Thu, 26 Jun 2014 21:56:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
Message-ID: <20140626195629.GC5714@two.firstfloor.org>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> show RCX == RIP even under strace.

If you think it's really worth the extra instruction?

It's not wrong, but it's not clear if it's useful.

-Andi

> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kernel/entry_64.S | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b25ca96..6624e18 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -143,7 +143,8 @@ ENDPROC(native_usergs_sysret64)
>  	movq \tmp,RSP+\offset(%rsp)
>  	movq $__USER_DS,SS+\offset(%rsp)
>  	movq $__USER_CS,CS+\offset(%rsp)
> -	movq $-1,RCX+\offset(%rsp)
> +	movq RIP+\offset(%rsp),\tmp  /* get rip */
> +	movq \tmp,RCX+\offset(%rsp)  /* copy it to rcx as sysret would do */
>  	movq R11+\offset(%rsp),\tmp  /* get eflags */
>  	movq \tmp,EFLAGS+\offset(%rsp)
>  	.endm
> -- 
> 1.9.3
> 

-- 
ak@linux.intel.com -- Speaking for myself only.

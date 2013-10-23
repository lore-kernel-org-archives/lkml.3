Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3JWBd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:33:59 -0400
Received: from ozlabs.org ([203.10.76.45]:56240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3JWBd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:33:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] x86, asmlinkage, lguest: Pass in globals into assembler statement
In-Reply-To: <1382458079-24450-2-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org> <1382458079-24450-2-git-send-email-andi@firstfloor.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 23 Oct 2013 10:55:29 +1030
Message-ID: <87wql4j0jq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> From: Andi Kleen <ak@linux.intel.com>
>
> Tell the compiler that the inline assembler statement
> references lguest_entry.
>
> This fixes compile problems with LTO where the variable
> and the assembler code may end up in different files.
>
> Cc: x86@kernel.org
> Cc: rusty@rustcorp.com.au
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Great, thanks.  Might as well keep this with the others:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

> ---
>  drivers/lguest/x86/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
> index 5169239..922a1ac 100644
> --- a/drivers/lguest/x86/core.c
> +++ b/drivers/lguest/x86/core.c
> @@ -157,7 +157,7 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
>  	 * stack, then the address of this call.  This stack layout happens to
>  	 * exactly match the stack layout created by an interrupt...
>  	 */
> -	asm volatile("pushf; lcall *lguest_entry"
> +	asm volatile("pushf; lcall *%4"
>  		     /*
>  		      * This is how we tell GCC that %eax ("a") and %ebx ("b")
>  		      * are changed by this routine.  The "=" means output.
> @@ -169,7 +169,9 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
>  		      * physical address of the Guest's top-level page
>  		      * directory.
>  		      */
> -		     : "0"(pages), "1"(__pa(cpu->lg->pgdirs[cpu->cpu_pgd].pgdir))
> +		     : "0"(pages), 
> +		       "1"(__pa(cpu->lg->pgdirs[cpu->cpu_pgd].pgdir)),
> +		       "m"(lguest_entry)
>  		     /*
>  		      * We tell gcc that all these registers could change,
>  		      * which means we don't have to save and restore them in
> -- 
> 1.8.3.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3JFJgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 05:36:19 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64588 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3JFJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 05:36:18 -0400
Date: Sun, 6 Oct 2013 11:36:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/early_iounmap: Let the compiler enter the function
 name
Message-ID: <20131006093614.GB4535@gmail.com>
References: <524D56CB.9080205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D56CB.9080205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> To be consistent with early_ioremap which had a change in
> commit 4f4319a ("x86/ioremap: Correct function name output"),
> let the complier enter the function name too.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/mm/ioremap.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 799580c..577bd8e 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -585,21 +585,21 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
>  	}
>  
>  	if (slot < 0) {
> -		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
> +		printk(KERN_INFO "%s(%p, %08lx) not found slot\n", __func__,

Would be nice to fix the spelling here as well then.

>  			 addr, size);
>  		WARN_ON(1);
>  		return;
>  	}
>  
>  	if (prev_size[slot] != size) {
> -		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
> -			 addr, size, slot, prev_size[slot]);
> +		printk(KERN_INFO "%s(%p, %08lx) [%d] size not consistent %08lx\n",
> +			 __func__, addr, size, slot, prev_size[slot]);

and here too, i.e. write:

	slot [%d] size [%08lx] not consistent with previous size [%08lx]

(Note that size can be duplicated there for completeness - even though 
it's included in the early_iounmap() printout already.)

>  	if (early_ioremap_debug) {
> -		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
> +		printk(KERN_INFO "%s(%p, %08lx) [%d]\n", __func__, addr,
>  		       size, slot);
>  		dump_stack();


I'd also stick that into a debug_print() helper define that prints the 
standard bits, leaving only the important bits at actual call sites:

		debug_print("size [%08lx] not consistent with previous size [%08lx]\n
		debug_print("call\n", addr, size, slot);

Thanks,

	Ingo

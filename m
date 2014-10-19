Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaJSJXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:23:32 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48855 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJSJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:23:30 -0400
Date: Sun, 19 Oct 2014 11:23:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v2 5/5] Numachip: use 2GB memory block size
Message-ID: <20141019092324.GA10027@gmail.com>
References: <1413683152-31302-1-git-send-email-daniel@numascale.com>
 <1413683152-31302-5-git-send-email-daniel@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413683152-31302-5-git-send-email-daniel@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale.com> wrote:

> Use appropriate memory block size to reduce sysfs entry creation time
> by 16x.
> 
> Boot-tested with the four permutations of X86_UV and X86_NUMACHIP.
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
> ---
>  arch/x86/mm/init_64.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 5621c47..22ea6de 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -53,6 +53,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/init.h>
>  #include <asm/uv/uv.h>
> +#include <asm/numachip/numachip.h>
>  #include <asm/setup.h>
>  
>  #include "mm_internal.h"
> @@ -1235,9 +1236,9 @@ static unsigned long probe_memory_block_size(void)
>  	/* start from 2g */
>  	unsigned long bz = 1UL<<31;
>  
> -#ifdef CONFIG_X86_UV
> -	if (is_uv_system()) {
> -		printk(KERN_INFO "UV: memory block size 2GB\n");
> +#ifdef CONFIG_X86_64
> +	if (is_uv_system() || is_numachip_system()) {
> +		pr_info("Memory block size 2GB for large-SMP system\n");
>  		return 2UL * 1024 * 1024 * 1024;

It would be a lot cleaner and more robust to have a more 
intelligent decision here.

Is there a reliable indicator for large 'sysfs entry creation 
time', such as a lot of RAM present?

Also, it would be nice to list the pros/cons of this change, an 
advantage is reduced overhead - what are the disadvantages?

Thanks,

	Ingo

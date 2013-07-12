Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3GLW15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:27:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41738 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab3GLW1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:27:53 -0400
Message-ID: <51E082B5.4020401@zytor.com>
Date: Fri, 12 Jul 2013 15:27:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] x86: make sure IDT is page aligned
References: <20130712183014.GA20551@www.outflux.net>
In-Reply-To: <20130712183014.GA20551@www.outflux.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:30 AM, Kees Cook wrote:
> Since the IDT is referenced from a fixmap, make sure it is page aligned.
> This avoids the risk of it ever being moved in the bss and having the
> fixmap fail.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: PaX Team <pageexec@freemail.hu>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/head_32.S |    2 +-
>  arch/x86/kernel/head_64.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index e65ddc6..3526dd1 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -734,7 +734,7 @@ boot_gdt_descr:
>  	.word __BOOT_DS+7
>  	.long boot_gdt - __PAGE_OFFSET
>  
> -	.word 0				# 32-bit align idt_desc.address
> +	.word PAGE_SIZE			# page align idt_desc.address
>  idt_descr:
>  	.word IDT_ENTRIES*8-1		# idt contains 256 entries
>  	.long idt_table
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 5e4d8a8..77e6d3e 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -513,7 +513,7 @@ ENTRY(phys_base)
>  #include "../../x86/xen/xen-head.S"
>  	
>  	.section .bss, "aw", @nobits
> -	.align L1_CACHE_BYTES
> +	.align PAGE_SIZE
>  ENTRY(idt_table)
>  	.skip IDT_ENTRIES * 16
>  
> 

You are aligning the IDT *descriptor*, not the IDT itself?

	-hpa


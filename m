Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaLAUsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:48:16 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61503 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:48:15 -0500
Message-ID: <547CD413.10803@googlemail.com>
Date: Mon, 01 Dec 2014 20:48:19 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, eternal.n08@gmail.com, keescook@chromium.org,
        hpa@linux.intel.com, hpa@zytor.com, tglx@linutronix.de, bp@suse.de,
        mingo@kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Use $(OBJDUMP) instead of plain objdump
References: <54705C8E.1080400@googlemail.com> <tip-e2e68ae688b0a3766cd75aedf4ed4e39be402009@git.kernel.org>
In-Reply-To: <tip-e2e68ae688b0a3766cd75aedf4ed4e39be402009@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is it planned to get this fix through in time for release of 3.18? It appears to have been in -next for a week.

Chris

On 11/23/14 20:24, tip-bot for Chris Clayton wrote:
> Commit-ID:  e2e68ae688b0a3766cd75aedf4ed4e39be402009
> Gitweb:     http://git.kernel.org/tip/e2e68ae688b0a3766cd75aedf4ed4e39be402009
> Author:     Chris Clayton <chris2553@googlemail.com>
> AuthorDate: Sat, 22 Nov 2014 09:51:10 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sun, 23 Nov 2014 21:21:53 +0100
> 
> x86: Use $(OBJDUMP) instead of plain objdump
> 
> commit e6023367d779 'x86, kaslr: Prevent .bss from overlaping initrd'
> broke the cross compile of x86. It added a objdump invocation, which
> invokes the host native objdump and ignores an active cross tool
> chain.
> 
> Use $(OBJDUMP) instead which takes the CROSS_COMPILE prefix into
> account.
> 
> [ tglx: Massage changelog and use $(OBJDUMP) ]
> 
> Fixes: e6023367d779 'x86, kaslr: Prevent .bss from overlaping initrd'
> Signed-off-by: Chris Clayton <chris2553@googlemail.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Acked-by: Borislav Petkov <bp@suse.de>
> Cc: Junjie Mao <eternal.n08@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: stable@vger.kernel.org
> Link: http://lkml.kernel.org/r/54705C8E.1080400@googlemail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/boot/compressed/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index be1e07d..45abc36 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -76,7 +76,7 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
>  suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
>  suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
>  
> -RUN_SIZE = $(shell objdump -h vmlinux | \
> +RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
>  	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
>  quiet_cmd_mkpiggy = MKPIGGY $@
>        cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
> 

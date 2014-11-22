Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKVLOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 06:14:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33163 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaKVLOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 06:14:47 -0500
Date: Sat, 22 Nov 2014 12:14:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Clayton <chris2553@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Junjie Mao <eternal.n08@gmail.com>,
        Kees Cook <keescook@chromium.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH]: cross-compiling x86_64 kernel on i386 user-space fails
Message-ID: <20141122111444.GA12445@pd.tnic>
References: <54705C8E.1080400@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54705C8E.1080400@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 09:51:10AM +0000, Chris Clayton wrote:
> Hi,

Yeah, next time make sure you actually CC people :-)

I've added them to CC now.

> Commit e6023367d779060fddc9a52d1f474085b2b36298 broke building an x86_64 kernel in an i386. The change added a call to
> objdump but neglected to cater for cross-compiling.
> 
> The patch below fixes the problem for me. I see the commit is now in 3.14 and 3.17 -stable, so the patch needs to go
> there too.

CC: stable@vger.kernel.org

in the commit message should help there.


> CC: Junjie Mao <eternal.n08@gmail.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Chris Clayton <chris2553@googlemail.com>

Acked-by: Borislav Petkov <bp@suse.de>

> ---
> --- linux/arch/x86/boot/compressed/Makefile~    2014-11-22 08:56:50.359706324 +0000
> +++ linux/arch/x86/boot/compressed/Makefile     2014-11-22 09:04:06.615693435 +0000
> @@ -76,7 +76,7 @@ suffix-$(CONFIG_KERNEL_XZ)    := xz
>  suffix-$(CONFIG_KERNEL_LZO)    := lzo
>  suffix-$(CONFIG_KERNEL_LZ4)    := lz4
> 
> -RUN_SIZE = $(shell objdump -h vmlinux | \
> +RUN_SIZE = $(shell ${CROSS_COMPILE}objdump -h vmlinux | \
>              perl $(srctree)/arch/x86/tools/calc_run_size.pl)
>  quiet_cmd_mkpiggy = MKPIGGY $@
>        cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

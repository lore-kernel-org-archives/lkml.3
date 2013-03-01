Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3CARrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:47:42 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47919 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CARrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:47:40 -0500
MIME-Version: 1.0
In-Reply-To: <tip-b317219b322e36e25150d7b64f4532401779959d@git.kernel.org>
References: <51300267.6000008@gmail.com>
	<tip-b317219b322e36e25150d7b64f4532401779959d@git.kernel.org>
Date: Fri, 1 Mar 2013 09:47:40 -0800
X-Google-Sender-Auth: C3ZsWaPnpuALDGVBZuYocDae9oU
Message-ID: <CAE9FiQWmwj2urS-jY-+Bifdzx1z3om839qOowz0QZHtxLQoVzA@mail.gmail.com>
Subject: Re: [tip:x86/cleanups] x86_64: Use __BOOT_DS instead_of __KERNEL_DS
 for safety
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, lans.zhang2008@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 9:23 PM, tip-bot for gmail <tipbot@zytor.com> wrote:
> Commit-ID:  b317219b322e36e25150d7b64f4532401779959d
> Gitweb:     http://git.kernel.org/tip/b317219b322e36e25150d7b64f4532401779959d
> Author:     gmail <lans.zhang2008@gmail.com>

name is messed up.

should be

Lans Zhang <lans.zhang2008@gmail.com>

> AuthorDate: Fri, 1 Mar 2013 09:20:39 +0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 28 Feb 2013 20:19:50 -0800
>
> x86_64: Use __BOOT_DS instead_of __KERNEL_DS for safety
>
> In startup_32, the running code still uses the initial GDT
> located in setup. Thus, __BOOT_DS is preferred. Currently
> __KERNEL_DS is lucky to equal to __BOOT_DS, but this is
> not always a safe way.
>
> Signed-off-by: Lans Zhang <lans.zhang2008@gmail.com>
> Link: http://lkml.kernel.org/r/51300267.6000008@gmail.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/boot/compressed/head_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index c1d383d..16f24e6 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -52,7 +52,7 @@ ENTRY(startup_32)
>         jnz 1f
>
>         cli
> -       movl    $(__KERNEL_DS), %eax
> +       movl    $(__BOOT_DS), %eax
>         movl    %eax, %ds
>         movl    %eax, %es
>         movl    %eax, %ss
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

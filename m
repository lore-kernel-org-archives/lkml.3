Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKEWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:10:52 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:40993 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKEWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <tip-bdee237c0343a5d1a6cf72c7ea68e88338b26e08@git.kernel.org>
References: <1415089784-28779-4-git-send-email-daniel@numascale.com>
	<tip-bdee237c0343a5d1a6cf72c7ea68e88338b26e08@git.kernel.org>
Date: Wed, 5 Nov 2014 14:10:48 -0800
X-Google-Sender-Auth: xacAdu05oYX2hltykq0ikWpqxPc
Message-ID: <CAE9FiQWSDJdEdDkiWog6xPLnmHo3xXtnnE0y6YGfuR8A5EkLNA@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86: mm: Use 2GB memory block size on large-memory
 x86-64 systems
From: Yinghai Lu <yinghai@kernel.org>
To: Steffen Persvold <sp@numascale.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Ingo Molnar <mingo@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 9:22 AM, tip-bot for Daniel J Blueman
<tipbot@zytor.com> wrote:
> Commit-ID:  bdee237c0343a5d1a6cf72c7ea68e88338b26e08
> Gitweb:     http://git.kernel.org/tip/bdee237c0343a5d1a6cf72c7ea68e88338b26e08
> Author:     Daniel J Blueman <daniel@numascale.com>
> AuthorDate: Tue, 4 Nov 2014 16:29:44 +0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 4 Nov 2014 18:19:27 +0100
>
> x86: mm: Use 2GB memory block size on large-memory x86-64 systems
>
> On large-memory x86-64 systems of 64GB or more with memory hot-plug
> enabled, use a 2GB memory block size. Eg with 64GB memory, this reduces
> the number of directories in /sys/devices/system/memory from 512 to 32,
> making it more manageable, and reducing the creation time accordingly.
>
> This caveat is that the memory can't be offlined (for hotplug or
> otherwise) with the finer default 128MB granularity, but this is
> unimportant due to the high memory densities generally used with such
> large-memory systems, where eg a single DIMM is the order of 16GB.
>
> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
> Cc: Steffen Persvold <sp@numascale.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Link: http://lkml.kernel.org/r/1415089784-28779-4-git-send-email-daniel@numascale.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/mm/init_64.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4cb8763..ebca30f 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -52,7 +52,6 @@
>  #include <asm/numa.h>
>  #include <asm/cacheflush.h>
>  #include <asm/init.h>
> -#include <asm/uv/uv.h>
>  #include <asm/setup.h>
>
>  #include "mm_internal.h"
> @@ -1247,12 +1246,10 @@ static unsigned long probe_memory_block_size(void)
>         /* start from 2g */
>         unsigned long bz = 1UL<<31;
>
> -#ifdef CONFIG_X86_UV
> -       if (is_uv_system()) {
> -               printk(KERN_INFO "UV: memory block size 2GB\n");
> +       if (totalram_pages >= (64ULL << (30 - PAGE_SHIFT))) {
> +               pr_info("Using 2GB memory block size for large-memory system\n");
>                 return 2UL * 1024 * 1024 * 1024;
>         }
> -#endif
>
>         /* less than 64g installed */
>         if ((max_pfn << PAGE_SHIFT) < (16UL << 32))
.....

Come on. Can you remove the following dead lines caused by this patch
the same time ?

Yinghai

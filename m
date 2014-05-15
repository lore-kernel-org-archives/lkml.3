Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaEOMEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:04:30 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57533 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaEOME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:04:27 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1397211951-20549-8-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-8-git-send-email-miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:04:26 +0200
Message-ID: <CAJfpegvKAKA-s6WP4Mbr104YvVREgzR_KPC=OA-h6K=oTTsKWw@mail.gmail.com>
Subject: Re: [PATCH 07/15] mips: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch <linux-arch@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Ralf Baechle <ralf@linux-mips.org>

Ralf,

I'll be sending a batch of patches with arch support for the renameat2
syscall to Linus next week.  If you'd like me to send this as well,
could you please ACK it?

Thanks,
Miklos


> ---
>  arch/mips/include/uapi/asm/unistd.h | 15 +++++++++------
>  arch/mips/kernel/scall32-o32.S      |  1 +
>  arch/mips/kernel/scall64-64.S       |  1 +
>  arch/mips/kernel/scall64-n32.S      |  1 +
>  arch/mips/kernel/scall64-o32.S      |  1 +
>  5 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/arch/mips/include/uapi/asm/unistd.h b/arch/mips/include/uapi/asm/unistd.h
> index d6e154a9e6a5..5805414777e0 100644
> --- a/arch/mips/include/uapi/asm/unistd.h
> +++ b/arch/mips/include/uapi/asm/unistd.h
> @@ -371,16 +371,17 @@
>  #define __NR_finit_module              (__NR_Linux + 348)
>  #define __NR_sched_setattr             (__NR_Linux + 349)
>  #define __NR_sched_getattr             (__NR_Linux + 350)
> +#define __NR_renameat2                 (__NR_Linux + 351)
>
>  /*
>   * Offset of the last Linux o32 flavoured syscall
>   */
> -#define __NR_Linux_syscalls            350
> +#define __NR_Linux_syscalls            351
>
>  #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
>
>  #define __NR_O32_Linux                 4000
> -#define __NR_O32_Linux_syscalls                350
> +#define __NR_O32_Linux_syscalls                351
>
>  #if _MIPS_SIM == _MIPS_SIM_ABI64
>
> @@ -699,16 +700,17 @@
>  #define __NR_getdents64                        (__NR_Linux + 308)
>  #define __NR_sched_setattr             (__NR_Linux + 309)
>  #define __NR_sched_getattr             (__NR_Linux + 310)
> +#define __NR_renameat2                 (__NR_Linux + 311)
>
>  /*
>   * Offset of the last Linux 64-bit flavoured syscall
>   */
> -#define __NR_Linux_syscalls            310
> +#define __NR_Linux_syscalls            311
>
>  #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
>
>  #define __NR_64_Linux                  5000
> -#define __NR_64_Linux_syscalls         310
> +#define __NR_64_Linux_syscalls         311
>
>  #if _MIPS_SIM == _MIPS_SIM_NABI32
>
> @@ -1031,15 +1033,16 @@
>  #define __NR_finit_module              (__NR_Linux + 312)
>  #define __NR_sched_setattr             (__NR_Linux + 313)
>  #define __NR_sched_getattr             (__NR_Linux + 314)
> +#define __NR_renameat2                 (__NR_Linux + 315)
>
>  /*
>   * Offset of the last N32 flavoured syscall
>   */
> -#define __NR_Linux_syscalls            314
> +#define __NR_Linux_syscalls            315
>
>  #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
>
>  #define __NR_N32_Linux                 6000
> -#define __NR_N32_Linux_syscalls                314
> +#define __NR_N32_Linux_syscalls                315
>
>  #endif /* _UAPI_ASM_UNISTD_H */
> diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
> index fdc70b400442..3245474f19d5 100644
> --- a/arch/mips/kernel/scall32-o32.S
> +++ b/arch/mips/kernel/scall32-o32.S
> @@ -577,3 +577,4 @@ EXPORT(sys_call_table)
>         PTR     sys_finit_module
>         PTR     sys_sched_setattr
>         PTR     sys_sched_getattr               /* 4350 */
> +       PTR     sys_renameat2
> diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
> index dd99c3285aea..be2fedd4ae33 100644
> --- a/arch/mips/kernel/scall64-64.S
> +++ b/arch/mips/kernel/scall64-64.S
> @@ -430,4 +430,5 @@ EXPORT(sys_call_table)
>         PTR     sys_getdents64
>         PTR     sys_sched_setattr
>         PTR     sys_sched_getattr               /* 5310 */
> +       PTR     sys_renameat2
>         .size   sys_call_table,.-sys_call_table
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index f68d2f4f0090..c1dbcda4b816 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -423,4 +423,5 @@ EXPORT(sysn32_call_table)
>         PTR     sys_finit_module
>         PTR     sys_sched_setattr
>         PTR     sys_sched_getattr
> +       PTR     sys_renameat2                   /* 6315 */
>         .size   sysn32_call_table,.-sysn32_call_table
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index 70f6acecd928..f1343ccd7ed7 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -556,4 +556,5 @@ EXPORT(sys32_call_table)
>         PTR     sys_finit_module
>         PTR     sys_sched_setattr
>         PTR     sys_sched_getattr               /* 4350 */
> +       PTR     sys_renameat2
>         .size   sys32_call_table,.-sys32_call_table
> --
> 1.8.1.4
>

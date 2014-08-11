Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHKQzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:55:53 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58504 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaHKQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
Date: Mon, 11 Aug 2014 18:55:50 +0200
Message-ID: <CANq1E4SyoMEXa7dX8PdYUckBJzL3V+FzZSoKUKqsgGnzPAVbFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: compat: wire up memfd_create and getrandom
 syscalls for aarch32
From: David Herrmann <dh.herrmann@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> arch/arm/ just grew support for the new memfd_create and getrandom
> syscalls, so add them to our compat layer too.
>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/unistd.h   | 2 +-
>  arch/arm64/include/asm/unistd32.h | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 4bc95d27e063..6d2bf419431d 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -41,7 +41,7 @@
>  #define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
>  #define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)
>
> -#define __NR_compat_syscalls           383
> +#define __NR_compat_syscalls           386
>  #endif
>
>  #define __ARCH_WANT_SYS_CLONE
> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> index e242600c4046..da1f06b535e3 100644
> --- a/arch/arm64/include/asm/unistd32.h
> +++ b/arch/arm64/include/asm/unistd32.h
> @@ -787,3 +787,8 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
>  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
>  #define __NR_renameat2 382
>  __SYSCALL(__NR_renameat2, sys_renameat2)
> +                       /* 383 for seccomp */

No idea what happens if you increase __NR_compat_syscalls without
adding __SYSCALL(). Apart from that, it's the same I have in my
private memfd-branch, so fine with me (I will then drop my
arm64-compat patch for memfd).

Thanks
David

> +#define __NR_getrandom 384
> +__SYSCALL(__NR_getrandom, sys_getrandom)
> +#define __NR_memfd_create 385
> +__SYSCALL(__NR_memfd_create, sys_memfd_create)
> --
> 2.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

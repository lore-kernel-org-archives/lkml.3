Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaHURwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:52:55 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50305 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaHURwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
	<1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org>
Date: Thu, 21 Aug 2014 12:52:53 -0500
X-Google-Sender-Auth: OC6LxcnkFJ2KhhajlVMSOzUUs5A
Message-ID: <CAGXu5jK9yThj5Ma1ajmQkNOfL1gggDebmFPdh-KV3R3BkveO_w@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] arm64: add seccomp syscall for compat task
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> This patch allows compat task to issue seccomp() system call.
>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/asm/unistd.h   |    2 +-
>  arch/arm64/include/asm/unistd32.h |    3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 4bc95d2..cf6ee31 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -41,7 +41,7 @@
>  #define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
>  #define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)
>
> -#define __NR_compat_syscalls           383
> +#define __NR_compat_syscalls           384
>  #endif
>
>  #define __ARCH_WANT_SYS_CLONE
> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> index e242600..2922c40 100644
> --- a/arch/arm64/include/asm/unistd32.h
> +++ b/arch/arm64/include/asm/unistd32.h
> @@ -787,3 +787,6 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
>  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
>  #define __NR_renameat2 382
>  __SYSCALL(__NR_renameat2, sys_renameat2)
> +#define __NR_seccomp 383
> +__SYSCALL(__NR_seccomp, sys_seccomp)
> +

Nit: this adds a trailing blank line. Other than that:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security

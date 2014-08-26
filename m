Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaHZRxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:53:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39600 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbaHZRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:53:17 -0400
Date: Tue, 26 Aug 2014 18:53:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/6] arm64: add seccomp syscall for compat task
Message-ID: <20140826175303.GE23445@arm.com>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
 <1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:56:43AM +0100, AKASHI Takahiro wrote:
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
>  #define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
>  #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
>  
> -#define __NR_compat_syscalls		383
> +#define __NR_compat_syscalls		384
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

This will need rebasing onto -rc2, as we're hooked up two new compat
syscalls recently.

Will

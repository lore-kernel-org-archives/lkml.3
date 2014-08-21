Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaHURvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:51:54 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:50875 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaHURvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1408611405-8943-4-git-send-email-takahiro.akashi@linaro.org>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
	<1408611405-8943-4-git-send-email-takahiro.akashi@linaro.org>
Date: Thu, 21 Aug 2014 12:51:51 -0500
X-Google-Sender-Auth: bmW9XwpOXnApkO1dW1OKaC6UkGU
Message-ID: <CAGXu5j+6kyiZqXF0pScqsCzqDonCthKSvYDVT5+vEd3+iY72vg@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] asm-generic: add generic seccomp.h for secure
 computing mode 1
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
> Those values (__NR_seccomp_*) are used solely in secure_computing()
> to identify mode 1 system calls. If compat system calls have different
> syscall numbers, asm/seccomp.h may override them.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 include/asm-generic/seccomp.h
>
> diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
> new file mode 100644
> index 0000000..5e97022
> --- /dev/null
> +++ b/include/asm-generic/seccomp.h
> @@ -0,0 +1,28 @@
> +/*
> + * include/asm-generic/seccomp.h
> + *
> + * Copyright (C) 2014 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _ASM_GENERIC_SECCOMP_H
> +#define _ASM_GENERIC_SECCOMP_H
> +
> +#include <asm-generic/unistd.h>

While this isn't a problem for ARM, this should be linux/unistd.h for
other architectures to get the right stuff.

> +
> +#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
> +#define __NR_seccomp_read_32           __NR_read
> +#define __NR_seccomp_write_32          __NR_write
> +#define __NR_seccomp_exit_32           __NR_exit
> +#define __NR_seccomp_sigreturn_32      __NR_rt_sigreturn
> +#endif /* CONFIG_COMPAT && ! already defined */
> +
> +#define __NR_seccomp_read              __NR_read
> +#define __NR_seccomp_write             __NR_write
> +#define __NR_seccomp_exit              __NR_exit
> +#define __NR_seccomp_sigreturn         __NR_rt_sigreturn

Some architectures use __NR_sigreturn, so this will need to be
adjusted in the future into:

#ifdef __NR_seccomp_sigreturn
#define __NR_seccomp_sigreturn         __NR_rt_sigreturn
#endif

After these changes, I was able to port x86 to using this
asm-generic/seccomp.h too.

-Kees

> +
> +#endif /* _ASM_GENERIC_SECCOMP_H */
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security

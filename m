Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbaGXDkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:40:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44601 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbaGXDkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:40:31 -0400
Message-ID: <53D0802A.7070703@amacapital.net>
Date: Wed, 23 Jul 2014 20:40:26 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, wad@chromium.org,
        catalin.marinas@arm.com, will.deacon@arm.com, keescook@chromium.org
CC: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] asm-generic: Add generic seccomp.h for secure
 computing mode 1
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-3-git-send-email-takahiro.akashi@linaro.org>
In-Reply-To: <1406020499-5537-3-git-send-email-takahiro.akashi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
> Those values (__NR_seccomp_*) are used solely in secure_computing()
> to identify mode 1 system calls. If compat system calls have different
> syscall numbers, asm/seccomp.h may override them.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>   include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
>   create mode 100644 include/asm-generic/seccomp.h
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
> +
> +#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
> +#define __NR_seccomp_read_32		__NR_read
> +#define __NR_seccomp_write_32		__NR_write
> +#define __NR_seccomp_exit_32		__NR_exit
> +#define __NR_seccomp_sigreturn_32	__NR_rt_sigreturn
> +#endif /* CONFIG_COMPAT && ! already defined */
> +
> +#define __NR_seccomp_read		__NR_read
> +#define __NR_seccomp_write		__NR_write
> +#define __NR_seccomp_exit		__NR_exit
> +#define __NR_seccomp_sigreturn		__NR_rt_sigreturn

I don't like these names.  __NR_seccomp_read sounds like the number of a 
syscall called seccomp_read.

Also, shouldn't something be including this header?  I'm confused.

--Andy

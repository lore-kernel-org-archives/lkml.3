Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaHVAiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:38:21 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42128 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaHVAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:38:20 -0400
Message-ID: <53F690F4.8060007@linaro.org>
Date: Fri, 22 Aug 2014 09:38:12 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/6] asm-generic: add generic seccomp.h for secure
 computing mode 1
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>	<1408611405-8943-4-git-send-email-takahiro.akashi@linaro.org> <CAGXu5j+6kyiZqXF0pScqsCzqDonCthKSvYDVT5+vEd3+iY72vg@mail.gmail.com>
In-Reply-To: <CAGXu5j+6kyiZqXF0pScqsCzqDonCthKSvYDVT5+vEd3+iY72vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:51 AM, Kees Cook wrote:
> On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
>> Those values (__NR_seccomp_*) are used solely in secure_computing()
>> to identify mode 1 system calls. If compat system calls have different
>> syscall numbers, asm/seccomp.h may override them.
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
>> ---
>>   include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>   create mode 100644 include/asm-generic/seccomp.h
>>
>> diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
>> new file mode 100644
>> index 0000000..5e97022
>> --- /dev/null
>> +++ b/include/asm-generic/seccomp.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * include/asm-generic/seccomp.h
>> + *
>> + * Copyright (C) 2014 Linaro Limited
>> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#ifndef _ASM_GENERIC_SECCOMP_H
>> +#define _ASM_GENERIC_SECCOMP_H
>> +
>> +#include <asm-generic/unistd.h>
>
> While this isn't a problem for ARM, this should be linux/unistd.h for
> other architectures to get the right stuff.

I will fix it.

>> +
>> +#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
>> +#define __NR_seccomp_read_32           __NR_read
>> +#define __NR_seccomp_write_32          __NR_write
>> +#define __NR_seccomp_exit_32           __NR_exit
>> +#define __NR_seccomp_sigreturn_32      __NR_rt_sigreturn
>> +#endif /* CONFIG_COMPAT && ! already defined */
>> +
>> +#define __NR_seccomp_read              __NR_read
>> +#define __NR_seccomp_write             __NR_write
>> +#define __NR_seccomp_exit              __NR_exit
>> +#define __NR_seccomp_sigreturn         __NR_rt_sigreturn
>
> Some architectures use __NR_sigreturn, so this will need to be
> adjusted in the future into:
>
> #ifdef __NR_seccomp_sigreturn
> #define __NR_seccomp_sigreturn         __NR_rt_sigreturn
> #endif

I will fix it.

> After these changes, I was able to port x86 to using this
> asm-generic/seccomp.h too.

Thanks,
-Takahiro AKASHI

> -Kees
>
>> +
>> +#endif /* _ASM_GENERIC_SECCOMP_H */
>> --
>> 1.7.9.5
>>
>
>
>

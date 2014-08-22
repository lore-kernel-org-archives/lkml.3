Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaHVAjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:39:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48304 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaHVAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:39:43 -0400
Message-ID: <53F69147.4040204@linaro.org>
Date: Fri, 22 Aug 2014 09:39:35 +0900
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
Subject: Re: [PATCH v6 4/6] arm64: add seccomp syscall for compat task
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>	<1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jK9yThj5Ma1ajmQkNOfL1gggDebmFPdh-KV3R3BkveO_w@mail.gmail.com>
In-Reply-To: <CAGXu5jK9yThj5Ma1ajmQkNOfL1gggDebmFPdh-KV3R3BkveO_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:52 AM, Kees Cook wrote:
> On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
>> This patch allows compat task to issue seccomp() system call.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/include/asm/unistd.h   |    2 +-
>>   arch/arm64/include/asm/unistd32.h |    3 +++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
>> index 4bc95d2..cf6ee31 100644
>> --- a/arch/arm64/include/asm/unistd.h
>> +++ b/arch/arm64/include/asm/unistd.h
>> @@ -41,7 +41,7 @@
>>   #define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
>>   #define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)
>>
>> -#define __NR_compat_syscalls           383
>> +#define __NR_compat_syscalls           384
>>   #endif
>>
>>   #define __ARCH_WANT_SYS_CLONE
>> diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
>> index e242600..2922c40 100644
>> --- a/arch/arm64/include/asm/unistd32.h
>> +++ b/arch/arm64/include/asm/unistd32.h
>> @@ -787,3 +787,6 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
>>   __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
>>   #define __NR_renameat2 382
>>   __SYSCALL(__NR_renameat2, sys_renameat2)
>> +#define __NR_seccomp 383
>> +__SYSCALL(__NR_seccomp, sys_seccomp)
>> +
>
> Nit: this adds a trailing blank line. Other than that:

I will fix it.
Thanks,

-Takahiro AKASHI

> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> -Kees
>
>> --
>> 1.7.9.5
>>
>
>
>

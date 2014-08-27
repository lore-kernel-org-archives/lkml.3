Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaH0F5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:57:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38384 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaH0F5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:57:16 -0400
Message-ID: <53FD7334.1070308@linaro.org>
Date: Wed, 27 Aug 2014 14:57:08 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/6] arm64: add seccomp syscall for compat task
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-5-git-send-email-takahiro.akashi@linaro.org> <20140826175303.GE23445@arm.com>
In-Reply-To: <20140826175303.GE23445@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 02:53 AM, Will Deacon wrote:
> On Thu, Aug 21, 2014 at 09:56:43AM +0100, AKASHI Takahiro wrote:
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
>>   #define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
>>   #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
>>
>> -#define __NR_compat_syscalls		383
>> +#define __NR_compat_syscalls		384
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
> This will need rebasing onto -rc2, as we're hooked up two new compat
> syscalls recently.

Thanks for heads-up. Fixed it.

-Takahiro AKASHI

> Will
>

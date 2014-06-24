Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFXXKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:10:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54889 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaFXXKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:10:23 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AA0553.6020909@roeck-us.net>
Date: Tue, 24 Jun 2014 16:10:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A9783C.7050206@gmail.com> <53A98F6F.4080503@roeck-us.net> <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 03:51 PM, David Rientjes wrote:
> On Tue, 24 Jun 2014, Guenter Roeck wrote:
>
>>> diff --git a/arch/score/include/uapi/asm/ptrace.h
>>> b/arch/score/include/uapi/asm/ptrace.h
>>> index f59771a..56e2de0 100644
>>> --- a/arch/score/include/uapi/asm/ptrace.h
>>> +++ b/arch/score/include/uapi/asm/ptrace.h
>>> @@ -4,16 +4,29 @@
>>>    #define PTRACE_GETREGS		12
>>>    #define PTRACE_SETREGS		13
>>>
>>> -#define PC		32
>>> -#define CONDITION	33
>>> -#define ECR		34
>>> -#define EMA		35
>>> -#define CEH		36
>>> -#define CEL		37
>>> -#define COUNTER		38
>>> -#define LDCR		39
>>> -#define STCR		40
>>> -#define PSR		41
>>> +#if !defined(__KERNEL__) || !defined(__linux__)
>>> +#define PC			32
>>> +#define CONDITION		33
>>> +#define ECR			34
>>> +#define EMA			35
>>> +#define CEH			36
>>> +#define CEL			37
>>> +#define COUNTER			38
>>> +#define LDCR			39
>>> +#define STCR			40
>>> +#define PSR			41
>>> +#else
>>> +#define SCORE_PC		32
>>> +#define SCORE_CONDITION		33
>>> +#define SCORE_ECR		34
>>> +#define SCORE_EMA		35
>>> +#define SCORE_CEH		36
>>> +#define SCORE_CEL		37
>>> +#define SCORE_COUNTER		38
>>> +#define SCORE_LDCR		39
>>> +#define SCORE_STCR		40
>>> +#define SCORE_PSR		41
>>> +#endif
>>>
>>>    #define SINGLESTEP16_INSN	0x7006
>>>    #define SINGLESTEP32_INSN	0x840C8000
>>>
>> That looks weird ... not sure if that is a good solution either.
>>
>> Are those defines actually used anywhere ? They don't seem to be used in the
>> kernel.
>>
>> Side note - an 'a' got missing in your headline.
>> And I'd suggest to abbreviate it to something like
>> 	score/uapi: ptrace.h:
>>
>
> Besides checking whether they are used in the kernel or not, I presume we
> would need to be fairly confident there are actual userspace usecases for
> these that require the change.  It begs the question of why these
> constants are too generic to be in the kernel but are acceptable in the
> set of userspace applications in the world.
>

That is another question. But for the time being it might be sufficient to
surround the defines with #if !defined(__KERNEL__) without introducing new
(and unused) kernel defines.

Guenter


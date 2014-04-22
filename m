Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaDVGXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:23:54 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54204 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaDVGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:23:50 -0400
Message-ID: <53560AF2.8000106@converseincode.com>
Date: Mon, 21 Apr 2014 23:23:46 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu
Subject: Re: [PATCH] x86: LLVMLinux: Wrap -mno-80387 with cc-option
References: <1398145227-25053-1-git-send-email-behanw@converseincode.com> <20140422060544.GA9133@gmail.com>
In-Reply-To: <20140422060544.GA9133@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 23:05, Ingo Molnar wrote:
> * behanw@converseincode.com <behanw@converseincode.com> wrote:
>
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Wrap -mno-80387 gcc options with cc-option so they don't break clang.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> ---
>>   arch/x86/Makefile | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>> index d1b7c37..ce6ad7e 100644
>> --- a/arch/x86/Makefile
>> +++ b/arch/x86/Makefile
>> @@ -83,7 +83,9 @@ else
>>           KBUILD_CFLAGS += -m64
>>   
>>           # Don't autogenerate traditional x87, MMX or SSE instructions
>> -        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
>> +        KBUILD_CFLAGS += -mno-mmx -mno-sse
>> +        KBUILD_CFLAGS += $(call cc-option,-mno-80387)
>> +        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
> Is there a clang equivalent option that inhibits all things FPU opcode
> generation by the compiler?
Not that I've found yet. Still investigating.

> That's the general purpose of -no-80387.
Yes, I understand what this is trying to accomplish. At this point I'd 
just like this new code not to break the use of clang with v3.15.

I will submit another patch which adds similar functionality when 
compiled with clang once I have that answer.

Behan

-- 
Behan Webster
behanw@converseincode.com


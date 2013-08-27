Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3H0EMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:12:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34451 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3H0EMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:12:43 -0400
X-Spam-Score: -101.0
Message-ID: <521C26FA.8050208@asianux.com>
Date: Tue, 27 Aug 2013 12:11:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>, Arnd Bergmann <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Dave Jones <davej@redhat.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300: include: asm: Kbuild: add gpio.h for pass compiling
References: <521B2AF7.6070806@asianux.com> <CAMuHMdXT+ezyFGNisEaz62ReHxeNzZq0XgKR905OtyhmCnu6Kg@mail.gmail.com> <521B3514.305@asianux.com>
In-Reply-To: <521B3514.305@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 06:59 PM, Chen Gang wrote:
> On 08/26/2013 06:21 PM, Geert Uytterhoeven wrote:
>> On Mon, Aug 26, 2013 at 12:16 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>> Need add default "gpio.h" for h8300, or can not pass compiling.
>>>
>>> The related error (allmodconfig for h8300):
>>>
>>>   arch/h8300/kernel/h8300_ksyms.c:17:22: fatal error: asm/gpio.h: No such file or directory
>>>    #include <asm/gpio.h>
>>>                         ^
>>
>> I this include needed at all? Perhaps it can just be removed?
>>
> 
> Pardon ?  Do you mean, only removing it  will be OK ?
> 
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  arch/h8300/include/asm/Kbuild |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
>>> index 8ada3cf..4c627aa 100644
>>> --- a/arch/h8300/include/asm/Kbuild
>>> +++ b/arch/h8300/include/asm/Kbuild
>>> @@ -1,6 +1,7 @@
>>>
>>>  generic-y += clkdev.h
>>>  generic-y += exec.h
>>> +generic-y += gpio.h
>>>  generic-y += linkage.h
>>>  generic-y += mmu.h
>>>  generic-y += module.h
>>
>> The only gpio-related exports in arch/h8300/kernel/h8300_ksyms.c are:
>>
>> EXPORT_SYMBOL(h8300_reserved_gpio);
>> EXPORT_SYMBOL(h8300_free_gpio);
>> EXPORT_SYMBOL(h8300_set_gpio_dir);
>>
>> and these are definitely not provided by asm-generic/gpio.h.
>>
> 
> Yeah, I will try to remove "#include <asm/gpio.h>" to see whether can
> pass compiling, tomorrow.  :-)
> 
> And now, I feel (just guess), it will not, for h8300 really need gpio
> (it has "gpio-internal.h"), commonly it will need "asm/gpio.h" too.
> 
> Tomorrow, I will try to prove whether my guess is correct or not.  ;-).
> 

After reading the related code (search "gpio.h" in root source tree),
it seems what you said is correct, my guess is incorrect.  :-(

Hmm... but better to get final conclusion after finish allmodconfig
compiling.

Now, I am compiling, and excuse me, I can not finish today because of
some issues (mainly for 'gcc 4.8.0', part for 'ld 2.22', and part for
kernel), I will 'process' them, hope can finish before 2013-08-31.


Welcome additional suggestions or completions.

Thanks.

> 
> Thanks.
> 
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>>
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a hacker. But
>> when I'm talking to journalists I just say "programmer" or something like that.
>>                                 -- Linus Torvalds
>>
>>
> 
> 


-- 
Chen Gang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3H0B7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:59:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26716 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H0B7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:59:12 -0400
X-Spam-Score: -101.0
Message-ID: <521C07AB.1010207@asianux.com>
Date: Tue, 27 Aug 2013 09:58:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300/kernel/setup.c: add "linux/initrd.h" to pass compiling
References: <521B2E75.1040802@asianux.com> <CAMuHMdVXJvLfmNLFFW=TBLOi2_mVyZy+kr46oM5GVz_PK-bbvA@mail.gmail.com> <521B369B.4010602@asianux.com> <CAMuHMdVYjtfV9-VdkbKwMecz_NJ9YcOdLYVfmcEXSypbZY_TkA@mail.gmail.com> <521B39CA.8060303@asianux.com> <20130826221240.GA12075@roeck-us.net>
In-Reply-To: <20130826221240.GA12075@roeck-us.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 06:12 AM, Guenter Roeck wrote:
> On Mon, Aug 26, 2013 at 07:19:38PM +0800, Chen Gang wrote:
>> On 08/26/2013 07:08 PM, Geert Uytterhoeven wrote:
>>> On Mon, Aug 26, 2013 at 1:06 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>> On 08/26/2013 07:00 PM, Geert Uytterhoeven wrote:
>>>>> On Mon, Aug 26, 2013 at 12:31 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>> --- a/arch/h8300/kernel/setup.c
>>>>>> +++ b/arch/h8300/kernel/setup.c
>>>>>> @@ -47,6 +47,9 @@
>>>>>>  #include <asm/regs267x.h>
>>>>>>  #endif
>>>>>>
>>>>>> +#if defined(CONFIG_BLK_DEV_INITRD)
>>>>>
>>>>> Why have you added the #ifdef?
>>>>>
>>>>
>>>> The related code is below (maybe we need add additional related
>>>> comments in the patch for it ?).
>>>>
>>>> in arch/h8300/kernel/setup.c
>>>>
>>>>  94 void __init setup_arch(char **cmdline_p)
>>>>  95 {
>>>>  96         int bootmap_size;
>>>>  97
>>>>  98         memory_start = (unsigned long) &_ramstart;
>>>>  99
>>>> 100         /* allow for ROMFS on the end of the kernel */
>>>> 101         if (memcmp((void *)memory_start, "-rom1fs-", 8) == 0) {
>>>> 102 #if defined(CONFIG_BLK_DEV_INITRD)
>>>> 103                 initrd_start = memory_start;
>>>> 104                 initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
>>>> 105 #else
>>>> 106                 memory_start += be32_to_cpu(((unsigned long *) memory_start)[2]);
>>>> 107 #endif
>>>> 108         }
>>>
>>> Sure, it's used conditionally. But it doesn't harm to always include it.
>>> That means less #ifdefs in the code.
>>>
>>
>> Hmm... I feel, add "#ifdefs" can make the code more clearer (consistent
>> with the "#ifdefs" 'for initrd_start' and 'end').
>>
> The goal in the Linux kernel is to reduce the amount of ifdefs in the code
> by moving conditional code as much as possible into header files. That actually
> has a practical advantage - it ensures that all code is compiled.
> 

Yeah, it should be.

> You may agree or disagree with this approach, but you should follow it and not
> add new ifdefs when you write kernel code, much less unnecessary ones.
> If anything, you might try to remove existing ifdefs while you are at it.
> 

Of cause, I agree.

And do you guess: "I do not agree with it" ?


>> For C code readers, more code doesn't mean more complex, if it can make
>> things clearer after add some more lines (and be sure of no negative
>> effect with performance), normally I prefer to add some more lines.
>>
> The Linux kernel community tends to think otherwise. For my part I don't
> see how ifdefs, and much more so unecessary ones, make anything clearer.
> I would argue you'll end up not seeing the forest because of all the trees.
> 

Hmm... it seems the 'clearer' depends on personal feelings (and 'clear'
does not mean 'code style'). 
 
For my feeling, when the code is more match the 'real world' and more
consistent with each other, it will be more clearer (maybe it is in
'bad code style').

In fact, 'forest' is not conflict with "all the trees", when we feel we
need discuss about it, it means both of them need improving.

  for satisfy "all the trees": need fix the issue.
  for satisfy "forest": need beautify code.


>> And this file has already had an area for all "#ifdefs include", I just
>> add it in this area, so at least, it can mach this file well, is it ?
>>
> Your argument is along the line of "the code is bad anyway, so it is ok
> to make it worse". Not really a good argument if you want to get your code
> accepted.
> 

So we need divide our current discussion contents into 2 patches.

  1st patch is for issue fix. it should follow the original 'coding styles' no matter whether it is good or bad.
    (it is just current patch).

  2nd patch is for 'beautify code', it should use 'correct' coding styles.
    (if possible I will send 2nd patch for it, it is not a bad idea to me if it can be applied). ;-)


> I would suggest to read Documentation/SubmittingPatches, section 2.2,
> before you continue with your line of argument.
> 

Yeah, I have already read it 6 months ago.

Hmm... but it is not bad idea for every members to read it once more
(including you and me).


> Guenter
> 
> 

Thanks.
-- 
Chen Gang

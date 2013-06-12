Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3FLVMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:12:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46577 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3FLVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:12:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWf-iqjQC=7w1gj3Lkqy229uFJxBya4bDDx14-+y-MU5w@mail.gmail.com>
References: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
	<CA+QCeVRdOOuh4aVZsQhucBNETnDp5OhAZguigLTbyD9bOONO1A@mail.gmail.com>
	<CAE9FiQXacn2abVKeBhTazgRBCS9EtiACs=fbB6_Y27ZpLOTq3w@mail.gmail.com>
	<CAKL7Q7rxkXDx49CgSjoVJSbER7ou+-yXa-yZg4hT4ktG_4gvHw@mail.gmail.com>
	<CAKL7Q7qUwTGexhr+8d88qN94YSCfSeOS-oLMh=KQ2NiOZRLbLQ@mail.gmail.com>
	<CAE9FiQWOvP+tTQ0Vakc9f-t61dv6Lo6dJm0+oH1On5k=6nvbXw@mail.gmail.com>
	<CAKL7Q7pbdVKFy=5Kq_KHnJ=rg0OjsUXFpTQrcdZXksR6qixszQ@mail.gmail.com>
	<CAE9FiQWf-iqjQC=7w1gj3Lkqy229uFJxBya4bDDx14-+y-MU5w@mail.gmail.com>
Date: Wed, 12 Jun 2013 23:12:38 +0200
Message-ID: <CAKL7Q7opor8nk=yJQMr-Smn90AMo9bJD_s6PY1ewF3uiOd6HZA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86, range: Do not add new blank slot with add_range_with_merge
From: "Joshua C." <joshuacov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sergey Meirovich <rathamahata@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/11 Yinghai Lu <yinghai@kernel.org>:
> On Tue, Jun 11, 2013 at 10:08 AM, Joshua C. <joshuacov@gmail.com> wrote:
>> 2013/6/11 Yinghai Lu <yinghai@kernel.org>:
>>> On Tue, Jun 11, 2013 at 3:04 AM, Joshua C. <joshuacov@gmail.com> wrote:
>>>> 2013/6/11 Joshua C. <joshuacov@gmail.com>:
>>>>> 2013/6/10 Yinghai Lu <yinghai@kernel.org>:
>>>>>> On Mon, Jun 10, 2013 at 3:55 AM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>>>>>>
>>>>>>> patches 1,2(latest one) have not helped me on 3.9.5:
>>>>>>
>>>>>> So v1:
>>>>>> https://patchwork.kernel.org/patch/2694981/
>>>>>> https://patchwork.kernel.org/patch/2694971/
>>>>>>
>>>>>> and v2:
>>>>>> https://patchwork.kernel.org/patch/2695891/
>>>>>> https://patchwork.kernel.org/patch/2695881/
>>>>>>
>>>>>> Neither of two versions fix the problem on your setup?
>>>>>>
>>>>>> Can you post boot log with mtrr_cleanup_debug on 3.9.4?
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Yinghai
>>>>>
>>>>> I got some warnings when trying to build v2 of the patches:
>>>>>
>>>>> # make -s ARCH=x86_64 V=1 -j4 bzImage
>>>>> kernel/range.c: In function 'add_range_with_merge':
>>>>> kernel/range.c:51:3: error: implicit declaration of function 'memmove'
>>>>> [-Werror=implicit-function-declaration]
>>>>> kernel/range.c:51:3: warning: incompatible implicit declaration of
>>>>> built-in function 'memmove' [enabled by default]
>>>>> cc1: some warnings being treated as errors
>>>>> scripts/Makefile.build:307: recipe for target 'kernel/range.o' failed
>>>>> make[1]: *** [kernel/range.o] Error 1
>>>>> Makefile:793: recipe for target 'kernel' failed
>>>>> make: *** [kernel] Error 2
>>>>> make: *** Waiting for unfinished jobs....
>>>>>
>>>>>
>>>>> --
>>>>> --joshua
>>>
>>> it does not report warning when I compile it with
>>>
>>> gcc (SUSE Linux) 4.7.2 20130108 [gcc-4_7-branch revision 195012
>>>
>>>>
>>>> A trivial fix for the above warnings:
>>>>
>>>> --- linux-2.6.orig/kernel/range.c
>>>> +++ linux-2.6/kernel/range.c
>>>> @@ -4,6 +4,7 @@
>>>>  #include <linux/kernel.h>
>>>>  #include <linux/init.h>
>>>>  #include <linux/sort.h>
>>>> +#include <linux/string.h>
>>>>
>>>>  #include <linux/range.h>
>>>>
>>
>> I use fedora17 with gcc version 4.7.3 (git checkout on 20130411). I
>> have no idea where this came from...
>
> Ok. Your config should have CONFIG_DYNAMIC_DEBUG defined,
> and my config does not have that defined.
>
> we have linux/kernel.h
>                 linux/printk.h
>                 linux/dynamic_debug.h
>
> dynamic_debug.h will include linux/string.h when CONFIG_DYNAMIC_DEBUG
> is not defined.
>
> Hi, Andrew,
>
> How to fix this inconsistency caused by dynamic_debug.h
>
> 1. let linux/kernel.h include string.h directly
> 2. or let dynamic_debug include string.h always
> 3. let printk.h include string.h.
> ...
>
> Yinghai

You guys are better at kernel coding than I am, but can't we just
directly add 'string.h' just like the small patch I posted? In the
worst case the file will be included twice... Maybe this is not a good
coding style but it solves the problem and doesn't cause any side
effects. So why not do it the way I did?

--
--joshua

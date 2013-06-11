Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3FKRIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:08:30 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61247 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3FKRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWOvP+tTQ0Vakc9f-t61dv6Lo6dJm0+oH1On5k=6nvbXw@mail.gmail.com>
References: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
	<CA+QCeVRdOOuh4aVZsQhucBNETnDp5OhAZguigLTbyD9bOONO1A@mail.gmail.com>
	<CAE9FiQXacn2abVKeBhTazgRBCS9EtiACs=fbB6_Y27ZpLOTq3w@mail.gmail.com>
	<CAKL7Q7rxkXDx49CgSjoVJSbER7ou+-yXa-yZg4hT4ktG_4gvHw@mail.gmail.com>
	<CAKL7Q7qUwTGexhr+8d88qN94YSCfSeOS-oLMh=KQ2NiOZRLbLQ@mail.gmail.com>
	<CAE9FiQWOvP+tTQ0Vakc9f-t61dv6Lo6dJm0+oH1On5k=6nvbXw@mail.gmail.com>
Date: Tue, 11 Jun 2013 19:08:27 +0200
Message-ID: <CAKL7Q7pbdVKFy=5Kq_KHnJ=rg0OjsUXFpTQrcdZXksR6qixszQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86, range: Do not add new blank slot with add_range_with_merge
From: "Joshua C." <joshuacov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sergey Meirovich <rathamahata@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/11 Yinghai Lu <yinghai@kernel.org>:
> On Tue, Jun 11, 2013 at 3:04 AM, Joshua C. <joshuacov@gmail.com> wrote:
>> 2013/6/11 Joshua C. <joshuacov@gmail.com>:
>>> 2013/6/10 Yinghai Lu <yinghai@kernel.org>:
>>>> On Mon, Jun 10, 2013 at 3:55 AM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>>>>
>>>>> patches 1,2(latest one) have not helped me on 3.9.5:
>>>>
>>>> So v1:
>>>> https://patchwork.kernel.org/patch/2694981/
>>>> https://patchwork.kernel.org/patch/2694971/
>>>>
>>>> and v2:
>>>> https://patchwork.kernel.org/patch/2695891/
>>>> https://patchwork.kernel.org/patch/2695881/
>>>>
>>>> Neither of two versions fix the problem on your setup?
>>>>
>>>> Can you post boot log with mtrr_cleanup_debug on 3.9.4?
>>>>
>>>> Thanks
>>>>
>>>> Yinghai
>>>
>>> I got some warnings when trying to build v2 of the patches:
>>>
>>> # make -s ARCH=x86_64 V=1 -j4 bzImage
>>> kernel/range.c: In function 'add_range_with_merge':
>>> kernel/range.c:51:3: error: implicit declaration of function 'memmove'
>>> [-Werror=implicit-function-declaration]
>>> kernel/range.c:51:3: warning: incompatible implicit declaration of
>>> built-in function 'memmove' [enabled by default]
>>> cc1: some warnings being treated as errors
>>> scripts/Makefile.build:307: recipe for target 'kernel/range.o' failed
>>> make[1]: *** [kernel/range.o] Error 1
>>> Makefile:793: recipe for target 'kernel' failed
>>> make: *** [kernel] Error 2
>>> make: *** Waiting for unfinished jobs....
>>>
>>>
>>> --
>>> --joshua
>
> it does not report warning when I compile it with
>
> gcc (SUSE Linux) 4.7.2 20130108 [gcc-4_7-branch revision 195012
>
>>
>> A trivial fix for the above warnings:
>>
>> --- linux-2.6.orig/kernel/range.c
>> +++ linux-2.6/kernel/range.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/init.h>
>>  #include <linux/sort.h>
>> +#include <linux/string.h>
>>
>>  #include <linux/range.h>
>>

I use fedora17 with gcc version 4.7.3 (git checkout on 20130411). I
have no idea where this came from...


--
--joshua

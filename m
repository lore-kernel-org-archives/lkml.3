Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3KNRmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:42:46 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42908 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3KNRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:42:38 -0500
Message-ID: <52850B89.10605@linux.com>
Date: Thu, 14 Nov 2013 18:42:33 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>	<20131113000358.GA2420@gmail.com> <CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
In-Reply-To: <CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-14 12:16 keltezéssel, Felipe Contreras írta:
> On Tue, Nov 12, 2013 at 6:03 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>>
>>> Otherwise we might not reboot when the user needs it the most (early
>>> on).
>>>
>>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>>> ---
>>>
>> [...]
>>>
>>> diff --git a/kernel/panic.c b/kernel/panic.c
>>> index b6c482c..d865263 100644
>>> --- a/kernel/panic.c
>>> +++ b/kernel/panic.c
>>> @@ -468,9 +468,23 @@ EXPORT_SYMBOL(__stack_chk_fail);
>>>
>>>  #endif
>>>
>>> -core_param(panic, panic_timeout, int, 0644);
>>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>>>
>>> +static int __init set_panic_timeout(char *val)
>>> +{
>>> +     long timeout;
>>> +     int ret;
>>> +
>>> +     ret = kstrtol(val, 0, &timeout);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     panic_timeout = timeout;
>>> +     return 0;
>>> +}
>>
>> I think the type of the 'timeout' local variable should match the type of
>> 'panic_timeout' (which is 'int', not 'long').
> 
> So you would rather have this?
> 
>   kstrtol(val, 0, (long *)&timeout);
> 
> Couldn't that potentially write the value beyond the memory allocated
> to 'timeout'?
> 

No, 'panic_timeout' is a variable of type 'int'.
Your 'long timeout;' line is wrong and should say 'int timeout;'


-- 
Regards,
Levente Kurusa

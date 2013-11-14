Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3KNLQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:16:10 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:47412 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3KNLQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131113000358.GA2420@gmail.com>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
	<20131113000358.GA2420@gmail.com>
Date: Thu, 14 Nov 2013 05:16:06 -0600
Message-ID: <CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 6:03 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> Otherwise we might not reboot when the user needs it the most (early
>> on).
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>
> [...]
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index b6c482c..d865263 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -468,9 +468,23 @@ EXPORT_SYMBOL(__stack_chk_fail);
>>
>>  #endif
>>
>> -core_param(panic, panic_timeout, int, 0644);
>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>>
>> +static int __init set_panic_timeout(char *val)
>> +{
>> +     long timeout;
>> +     int ret;
>> +
>> +     ret = kstrtol(val, 0, &timeout);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     panic_timeout = timeout;
>> +     return 0;
>> +}
>
> I think the type of the 'timeout' local variable should match the type of
> 'panic_timeout' (which is 'int', not 'long').

So you would rather have this?

  kstrtol(val, 0, (long *)&timeout);

Couldn't that potentially write the value beyond the memory allocated
to 'timeout'?

-- 
Felipe Contreras

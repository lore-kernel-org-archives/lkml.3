Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3KKOR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:17:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44838 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3KKORN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:17:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131111134459.GA8781@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-2-git-send-email-felipe.contreras@gmail.com>
	<20131111134459.GA8781@gmail.com>
Date: Mon, 11 Nov 2013 08:17:12 -0600
Message-ID: <CAMP44s3fm+DhHfGZG2SFL8gV2rZbbUHHpfYajhqDUeTJ_-AcAg@mail.gmail.com>
Subject: Re: [PATCH 1/3] panic: setup panic_timeout early
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

On Mon, Nov 11, 2013 at 7:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> Otherwise we might not reboot when the user needs it the most (early
>> on).
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  kernel/panic.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index b6c482c..46e37ff 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -468,9 +468,21 @@ EXPORT_SYMBOL(__stack_chk_fail);
>>
>>  #endif
>>
>> -core_param(panic, panic_timeout, int, 0644);
>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>>
>> +static int __init set_panic_timeout(char *str)
>> +{
>> +     int timeout;
>> +
>> +     if (!get_option(&str, &timeout))
>> +             return -EINVAL;
>> +
>> +     panic_timeout = timeout;
>> +     return 0;
>> +}
>> +
>> +early_param("panic_timeout", set_panic_timeout);
>> +
>
> For simple integer parameters simple_strtol() is better and (a tiny bit)
> faster.

simple_strtol() is deprecated in favor of kstrtol().

-- 
Felipe Contreras

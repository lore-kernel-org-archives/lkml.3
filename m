Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3KPU2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:28:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53349 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3KPU15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:27:57 -0500
MIME-Version: 1.0
In-Reply-To: <5287D3DA.4060601@linux.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
	<1384623151-31302-4-git-send-email-felipe.contreras@gmail.com>
	<5287D3DA.4060601@linux.com>
Date: Sat, 16 Nov 2013 14:27:56 -0600
Message-ID: <CAMP44s2URjS9ESbNrMDdQvAs6tWHPF4brm9hOMSTfGjRwkkR3Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] cmdline: declare exported symbols immediately
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 2:21 PM, Levente Kurusa <levex@linux.com> wrote:
> 2013-11-16 18:32 keltezéssel, Felipe Contreras írta:
>> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>> +EXPORT_SYMBOL(memparse);
>>
>> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>> +EXPORT_SYMBOL(get_option);
>>
>> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>> +EXPORT_SYMBOL(get_options);
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  lib/cmdline.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/cmdline.c b/lib/cmdline.c
>> index 5466333..d4932f7 100644
>> --- a/lib/cmdline.c
>> +++ b/lib/cmdline.c
>> @@ -67,6 +67,7 @@ int get_option(char **str, int *pint)
>>
>>       return 1;
>>  }
>> +EXPORT_SYMBOL(get_option);
>>
>>  /**
>>   *   get_options - Parse a string into a list of integers
>> @@ -112,6 +113,7 @@ char *get_options(const char *str, int nints, int *ints)
>>       ints[0] = i - 1;
>>       return (char *)str;
>>  }
>> +EXPORT_SYMBOL(get_options);
>>
>>  /**
>>   *   memparse - parse a string with mem suffixes into a number
>> @@ -152,7 +154,4 @@ unsigned long long memparse(const char *ptr, char **retptr)
>>
>>       return ret;
>>  }
>> -
>>  EXPORT_SYMBOL(memparse);
>> -EXPORT_SYMBOL(get_option);
>> -EXPORT_SYMBOL(get_options);
>>
>
> I don't know about this one, but I have seen lots of files where EXPORT_SYMBOLs were
> listed at the end of the file. To avoid misunderstanding, I still think that having the
> exports after the function is more appropriate.

If that was appropriate then checkpatch should be updated to remove
that warning, but presumably it's desirable to have them one next to
the other.

-- 
Felipe Contreras

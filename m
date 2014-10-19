Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaJSMUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 08:20:20 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:37053 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaJSMUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 08:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <1413682735.14629.11.camel@perches.com>
References: <1413669800-6058-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1413682735.14629.11.camel@perches.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 19 Oct 2014 14:19:57 +0200
Message-ID: <CAFo99gaLyzQoLAyBw9uEU=qiDnESH-rP1NL_+w8JLDw6BQMhaw@mail.gmail.com>
Subject: Re: [PATCH 1/5] lib: string.c: Added a function strzcpy
To: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-19 3:38 GMT+02:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-10-19 at 00:03 +0200, Rickard Strandqvist wrote:
>> Added a function strzcpy which works the same as strncpy,
>> but guaranteed to produce the trailing null character.
>>
>> There are many places in the code where strncpy used although it
>> must be zero terminated, and switching to strlcpy is not an option
>> because the string must nonetheless be fyld with zero characters.
> []
>> diff --git a/lib/string.c b/lib/string.c
> []
>> +char *strzcpy(char *dest, const char *src, size_t count)
>> +{
>> +     char *tmp = dest;
>> +
>> +     while (count) {
>> +             if ((*tmp = *src) != 0)
>> +                     src++;
>> +             tmp++;
>> +             count--;
>> +     }
>> +
>> +     if (dest != tmp)
>> +             *--tmp = '\0';
>> +
>> +     return dest;
>> +}
>
> why not
>
> char *strzcpy(char *dest, const char *src, size_t count)
> {
>         strncpy(dest, src, count)
>         if (count)
>                 dest[count - 1] = 0; /* or '\0' or whatever */
>
>         return dest;
> }
>
> maybe use static inline too.
>

Hi Joe

Yes this solution have also been discussed.
https://lkml.org/lkml/2014/10/16/682

Very possible that it is a better solution.
The code that I use in strzcpy is not the way I'd written it, but is
the same as in strncpy now.

But as I understand it the real strncpy code is normally highly
optimized for the hardware it runs on.
Ex: arch/x86/lib/string_32.c

But missing for x86 64 bit and Arm..?


Kind regards
Rickard Strandqvist

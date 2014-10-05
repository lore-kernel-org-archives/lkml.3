Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaJEQCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:02:09 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34788 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJEQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:02:05 -0400
MIME-Version: 1.0
In-Reply-To: <1412523392.2916.3.camel@joe-AO725>
References: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1412515757-19689-2-git-send-email-rickard_strandqvist@spectrumdigital.se> <1412523392.2916.3.camel@joe-AO725>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 5 Oct 2014 18:01:43 +0200
Message-ID: <CAFo99gZp9WuxjJCwDmNStrm3uQRJq9VKRDZ3yT5R9rDrwft=oA@mail.gmail.com>
Subject: Re: [PATCH] lib: string.c: A speed optimized for strncpy
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

Hi

Yes, it can be faster, even if it is as you say, probably a difference
depending on the size of the count.
And even greater need to test this on a variety of hardware :-/

But I try to do my test with the memset variant to.

Kind regards
Rickard Strandqvist


2014-10-05 17:36 GMT+02:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-10-05 at 15:29 +0200, Rickard Strandqvist wrote:
>> This variant is in my tests about 7-10% faster, and also think
>> it is perhaps even clearer code than before.
> []
>> diff --git a/lib/string.c b/lib/string.c
> []
>> @@ -123,12 +123,12 @@ char *strncpy(char *dest, const char *src, size_t count)
>>  {
>>       char *tmp = dest;
>>
>> -     while (count) {
>> -             if ((*tmp = *src) != 0)
>> -                     src++;
>> -             tmp++;
>> -             count--;
>> -     }
>> +     while (count && (*tmp++ = *src++))
>> +             --count;
>> +
>> +     while (count--)
>> +             *tmp++ = '\0';
>
> Perhaps it could be faster to use memset.
> It might depend on the value of count.
>
> {
>         while (count && (*tmp++ = *src++))
>                 count--;
>
>         if (count > 0)
>                 memset(tmp, 0, count);
> }
>

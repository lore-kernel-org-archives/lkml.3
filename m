Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbbAVNi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:38:59 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:62838 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVNiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:38:55 -0500
MIME-Version: 1.0
In-Reply-To: <20150121193909.GA15481@linux.com>
References: <aksgarg1989@gmail.com>
	<1421868386-77010-1-git-send-email-aksgarg1989@gmail.com>
	<20150121193909.GA15481@linux.com>
Date: Thu, 22 Jan 2015 19:08:55 +0530
Message-ID: <CA+HOOsgz=bRMjK7RYftirbPMzhx7HrguEm8k6p-t8a=0jScOnQ@mail.gmail.com>
Subject: Re: [PATCH] lib/kstrtox.c break if overflow is detected
From: Anshul Garg <aksgarg1989@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: akpm@linux-foundation.org, Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org,
        "anshul.g@samsung.com" <anshul.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Levente ,


Thanks for the reply.

I will segregate this patch in two different patches.

I will send these patches again.


Thanks
Anshul Garg



On Thu, Jan 22, 2015 at 1:09 AM, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> On Wed, Jan 21, 2015 at 11:26:26AM -0800, Anshul Garg wrote:
>> From: Anshul Garg <aksgarg1989@gmail.com>
>>
>> 1. While converting string representation to integer
>> break the loop if overflow is detected.
>> 2. Clean kstrtoll function
>>
>> Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
>> ---
>>  lib/kstrtox.c |   28 +++++++++++++---------------
>>  1 file changed, 13 insertions(+), 15 deletions(-)
>>
>> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
>> index ec8da78..8cbe5ca 100644
>> --- a/lib/kstrtox.c
>> +++ b/lib/kstrtox.c
>> @@ -70,8 +70,10 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
>>                * it in the max base we support (16)
>>                */
>>               if (unlikely(res & (~0ull << 60))) {
>> -                     if (res > div_u64(ULLONG_MAX - val, base))
>> +                     if (res > div_u64(ULLONG_MAX - val, base)) {
>>                               overflow = 1;
>> +                             break;
>> +                     }
>>               }
>>               res = res * base + val;
>>               rv++;
>> @@ -146,23 +148,19 @@ EXPORT_SYMBOL(kstrtoull);
>>  int kstrtoll(const char *s, unsigned int base, long long *res)
>>  {
>>       unsigned long long tmp;
>> -     int rv;
>> +     int rv, sign = 1;
>>
>>       if (s[0] == '-') {
>> -             rv = _kstrtoull(s + 1, base, &tmp);
>> -             if (rv < 0)
>> -                     return rv;
>> -             if ((long long)(-tmp) >= 0)
>> -                     return -ERANGE;
>> -             *res = -tmp;
>> -     } else {
>> -             rv = kstrtoull(s, base, &tmp);
>> -             if (rv < 0)
>> -                     return rv;
>> -             if ((long long)tmp < 0)
>> -                     return -ERANGE;
>> -             *res = tmp;
>> +             sign = -1;
>> +             s++;
>>       }
>> +
>> +     rv = kstrtoull(s, base, &tmp);
>> +     if (rv < 0)
>> +             return rv;
>> +     if ((long long)tmp < 0)
>> +             return -ERANGE;
>> +     *res = sign * tmp;
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(kstrtoll);
>
> Looks correct to me, so:
>
> Reviewed-by: Levente Kurusa <levex@linux.com>
>
> But I believe the two hunks are completely unrelated to
> eachother and hence should split into a patch series.
>
> Could you please do that and resend? Or if Andrew is OK
> with picking it up as is, then it's fine.
>
> Thanks,
>     Levente.

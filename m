Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaJPUjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:39:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37927 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaJPUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <20141016182543.GP17447@titan.lakedaemon.net>
References: <1413483355-29650-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141016182543.GP17447@titan.lakedaemon.net>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 16 Oct 2014 22:38:53 +0200
Message-ID: <CAFo99gan7ufzyt1k6zR=G0o=qDqpCh1TKcdqbjBTaTYBj7YVYA@mail.gmail.com>
Subject: Re: [PATCH v4] char: hw_random: core.c: Changed from using strncat to strlcat
To: Jason Cooper <jason@lakedaemon.net>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-16 20:25 GMT+02:00 Jason Cooper <jason@lakedaemon.net>:
> On Thu, Oct 16, 2014 at 08:15:55PM +0200, Rickard Strandqvist wrote:
>> The buf is used to hold the list of hwrng devices registered.
>> The old code ensures we don't walk off the end of buf as we
>> fill it, but it's unnecessarily complicated and thus difficult
>> to maintain. Simplify it by using strlcat.
>
>> We also ensure the string within buf is NULL terminated
>> so the final strlen is ok.
>
> This text is no longer necessary.
>
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> Please add my:
>
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
>
> to the next version of this patch.  It makes the maintainers job a *lot*
> easier not having to sift through old threads collecting up all the
> tags.
>
> thx,
>
> Jason.
>
>> ---
>>  drivers/char/hw_random/core.c |   11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index aa30a25..25599ea 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -281,7 +281,7 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>                                        char *buf)
>>  {
>>       int err;
>> -     ssize_t ret = 0;
>> +     ssize_t ret;
>>       struct hwrng *rng;
>>
>>       err = mutex_lock_interruptible(&rng_mutex);
>> @@ -289,13 +289,10 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>               return -ERESTARTSYS;
>>       buf[0] = '\0';
>>       list_for_each_entry(rng, &rng_list, list) {
>> -             strncat(buf, rng->name, PAGE_SIZE - ret - 1);
>> -             ret += strlen(rng->name);
>> -             strncat(buf, " ", PAGE_SIZE - ret - 1);
>> -             ret++;
>> +             strlcat(buf, rng->name, PAGE_SIZE);
>> +             strlcat(buf, " ", PAGE_SIZE);
>>       }
>> -     strncat(buf, "\n", PAGE_SIZE - ret - 1);
>> -     ret++;
>> +     ret = strlcat(buf, "\n", PAGE_SIZE);
>>       mutex_unlock(&rng_mutex);
>>
>>       return ret;
>> --
>> 1.7.10.4
>>

Hello again

I was not sure how I would do with others Reviewed-by:
But then I know it, did not seem obvious to do, because I actually
change some code in between.

And I also think about my change, which is actually wrong with using
the return value from strlcat the same reason as I mentioned before,
it can return strlen + 1
So sorry Joe, I do not think we even can do that :-(

So back to my previous patch then, also I update the text again.

Kind regards
Rickard Strandqvist

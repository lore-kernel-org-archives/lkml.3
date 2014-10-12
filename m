Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaJLKdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 06:33:13 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42253 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaJLKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 06:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
References: <1413067004-10925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 12 Oct 2014 12:32:46 +0200
Message-ID: <CAFo99gZWwtVjL+7EmJ_qfd9923bdDfOV+D2ucGnodPUdwM6SqA@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: core.c: Changed from using strncpy to strlcpy
To: Mark D Rustad <mrustad@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Oops, sorry.
New patch on the way!

Kind regards
Rickard Strandqvist


2014-10-12 2:27 GMT+02:00 Mark D Rustad <mrustad@gmail.com>:
> On Oct 11, 2014, at 3:36 PM, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> Changed from using strncpy to strlcpy to simplify the code
>
> Actually you changed from using strncat to strlcat.
>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>> drivers/char/hw_random/core.c |   12 ++++--------
>> 1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index aa30a25..1500cfd 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>                                        char *buf)
>> {
>>       int err;
>> -     ssize_t ret = 0;
>>       struct hwrng *rng;
>>
>>       err = mutex_lock_interruptible(&rng_mutex);
>> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
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
>> +     strlcat(buf, "\n", PAGE_SIZE);
>>       mutex_unlock(&rng_mutex);
>>
>> -     return ret;
>> +     return strlen(buf);
>> }
>>
>> static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
>> --
>> 1.7.10.4
>
> --
> Mark Rustad, MRustad@gmail.com
>

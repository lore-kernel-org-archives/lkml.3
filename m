Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaJMVU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 17:20:59 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35021 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaJMVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 17:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141012192209.GC14147@titan.lakedaemon.net>
References: <1413110971-17392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141012192209.GC14147@titan.lakedaemon.net>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 13 Oct 2014 23:20:35 +0200
Message-ID: <CAFo99gamwyykRnV0nwQpjp41fJSETKik1e2CVwnHX0DXzOdhzA@mail.gmail.com>
Subject: Re: [PATCH v2] char: hw_random: core.c: Changed from using strncat to strlcat
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

2014-10-12 21:22 GMT+02:00 Jason Cooper <jason@lakedaemon.net>:
> Rickard,
>
> On Sun, Oct 12, 2014 at 12:49:31PM +0200, Rickard Strandqvist wrote:
>> Changed from using strncat to strlcat to simplify the code
>
> I'd like to see a little more explicit discussion here.  As Guenter got
> caught up in the mis-understanding, I doubt he'd be the only one.  I
> think it's worth spelling out that the old code prevents overflowing the
> buffer 'buf' of size PAGE_SIZE.  And that strlcat() does that internally
> allowing this code to be more readable.
>
> It should also be mentioned that the final strlen(buf) is safe because
> every operation on buf will insert a NULL terminator within the
> buffers limit.
>
> thx,
>
> Jason.
>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/char/hw_random/core.c |   12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index aa30a25..1500cfd 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>                                        char *buf)
>>  {
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
>>  }
>>
>>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
>> --
>> 1.7.10.4


Hi

Do not know if I understand this right, you want to explain strlcat
function better then ..?

All these features are more or less stupid really.
You can also read what Linus thinks about this here.

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


But while I think this is something you have to learn, rather than
typing it in git comment.

But sure, it's just what i think :-)
Come with a suggestion what you want I add it...


Kind regards
Rickard Strandqvist

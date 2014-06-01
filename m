Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaFAMDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:03:21 -0400
Received: from smtp-out-136.synserver.de ([212.40.185.136]:1061 "EHLO
	smtp-out-136.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbaFAMDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:03:17 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29561
Message-ID: <538B167E.9030902@metafoo.de>
Date: Sun, 01 Jun 2014 14:03:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jonathan Cameron <jic23@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: ad_sigma_delta.c: Cleaning up uninitialized
 variables
References: <1401577904-4764-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <538AEF16.5070904@metafoo.de> <CAFo99gaTK__WX4oTr_jF6PZuTOsX8qbR9kRJbgamZPO4iGz53w@mail.gmail.com>
In-Reply-To: <CAFo99gaTK__WX4oTr_jF6PZuTOsX8qbR9kRJbgamZPO4iGz53w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 01:51 PM, Rickard Strandqvist wrote:
> Hi
>
> Believe it reacted to the code below.
>
> If raw_sample = 0 is the correct starting value, I am not sure. But
> leaving it uninitialized, I think is the worst choice.
>
>
>      if (ret < 0)
>          goto out;
>
>      ret = ad_sd_read_reg(sigma_delta, AD_SD_REG_DATA,
>          DIV_ROUND_UP(chan->scan_type.realbits + chan->scan_type.shift, 8),
>          &raw_sample);
> ....
> out:
> ....

you skipped the:

     if (ret)
         return ret;

that is here.

>      sample = raw_sample >> chan->scan_type.shift;
>

The code is a bit confusing and it is understandable that a static checker 
might generate a false positive. The fix though is not to silence the false 
positive as this will hide actual problems if they should come up by future 
modifications of the code.

>
> Best regards
> Rickard Strandqvist
>
>
> 2014-06-01 11:15 GMT+02:00 Lars-Peter Clausen <lars@metafoo.de>:
>> On 06/01/2014 01:11 AM, Rickard Strandqvist wrote:
>>>
>>> There is a risk that the variable will be used without being initialized.
>>>
>>> This was largely found by using a static code analysis program called
>>> cppcheck.
>>
>>
>> This looks like a false positive. And if it was not a false positive the
>> correct fix certainly is not to initialize the variable to some random value
>> to silence the warning.
>>
>> - Lars
>>


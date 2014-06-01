Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbaFALv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:51:56 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40954 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaFALvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <538AEF16.5070904@metafoo.de>
References: <1401577904-4764-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<538AEF16.5070904@metafoo.de>
Date: Sun, 1 Jun 2014 13:51:54 +0200
Message-ID: <CAFo99gaTK__WX4oTr_jF6PZuTOsX8qbR9kRJbgamZPO4iGz53w@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: ad_sigma_delta.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Believe it reacted to the code below.

If raw_sample = 0 is the correct starting value, I am not sure. But
leaving it uninitialized, I think is the worst choice.


    if (ret < 0)
        goto out;

    ret = ad_sd_read_reg(sigma_delta, AD_SD_REG_DATA,
        DIV_ROUND_UP(chan->scan_type.realbits + chan->scan_type.shift, 8),
        &raw_sample);
....
out:
....
    sample = raw_sample >> chan->scan_type.shift;


Best regards
Rickard Strandqvist


2014-06-01 11:15 GMT+02:00 Lars-Peter Clausen <lars@metafoo.de>:
> On 06/01/2014 01:11 AM, Rickard Strandqvist wrote:
>>
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called
>> cppcheck.
>
>
> This looks like a false positive. And if it was not a false positive the
> correct fix certainly is not to initialize the variable to some random value
> to silence the warning.
>
> - Lars
>

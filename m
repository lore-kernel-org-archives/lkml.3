Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaGIMKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:10:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36107 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaGIMKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYbK3tizezXNaTBT6ANQ8fxoBUH5OATpb5cLykQqRSuKA@mail.gmail.com>
References: <cover.1404665589.git.himangi774@gmail.com> <CACRpkdYbK3tizezXNaTBT6ANQ8fxoBUH5OATpb5cLykQqRSuKA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 9 Jul 2014 21:10:29 +0900
Message-ID: <CAAVeFuLKdah5JHoetoSwZTxd4qAioCSFEWGgMCv1tY1_BSZowg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Introduce a managed function for gpio_request_array
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Rob Jones <rob.jones@codethink.co.uk>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 7:14 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Jul 6, 2014 at 7:46 PM, Himangi Saraogi <himangi774@gmail.com> wrote:
>
>> This patchset intoduces a new managed interface devm_gpio_request_array,
>> adds it in the documentation and its declaration in the gpio.h include
>> file. Some cases of gpio_request_array are changed to
>> devm_gpio_request_array.
>>
>> Himangi Saraogi (5):
>>   gpiolib: devres: Introduce the function devm_request_gpio_array
>>   ASoC: wm1250-ev1: Use devm_gpio_request_array
>>   ASoC: pxa: Use devm_gpio_request_array
>>   ASoC: pxa: e800_wm9712: Introduce the use of devm_gpio_request_array
>>   ASoC: pxa/hx4700: Introduce the use of devm_gpio_request_array
>
> Sorry, we're not encouraging extension of the old gpio* plain API anymore.
>
> The right thing to do is convert users over to using GPIO descriptors
> internally, then introduce devm_gpiod_get_array() if that makes some
> sense.
>
> Alexandre, what do you say?

I do agree that we want to discourage people from using the integer
API, and would also prefer to see the consumers converted to gpiod and
proper gpiod functions introduced.

On the other hand with Rob's similar patch which seems to be about to
be merged (https://lkml.org/lkml/2014/7/2/149 ) I guess the pressure
to accept one or the other is quite high. At least, I hope Rob or
Himangi will follow-up with a patch adding similar functionality to
the gpiod API, and will consider converting their consumers to it
(it's for your own good!).

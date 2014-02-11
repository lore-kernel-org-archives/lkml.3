Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaBKKeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:34:07 -0500
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:52705 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbaBKKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:34:04 -0500
X-Greylist: delayed 6607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 05:34:04 EST
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJ6BP4JnVb6qD1DYXqPQ3zBKw8hb+xLqcmUjktOxAjdGA@mail.gmail.com>
References: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuJ6BP4JnVb6qD1DYXqPQ3zBKw8hb+xLqcmUjktOxAjdGA@mail.gmail.com>
Date: Tue, 11 Feb 2014 09:06:09 +0100
Message-ID: <CACh+v5Nj+qAD4LHXfX5=Ww_v5N9vvm=O_r29X3H1dKseeafauQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: take in account the active low flag when
 configuring the gpio as an ouput
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 15704896325675538456
X-Ovh-Remote: 209.85.220.44 (mail-pa0-f44.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

I somehow missed this one. Forget about my patch then.

Jean-Jacques

2014-02-11 5:22 GMT+01:00 Alexandre Courbot <gnurou@gmail.com>:
> On Tue, Feb 11, 2014 at 12:03 AM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>> The initial value of the gpio is passed to gpiod_direction_output. Currently
>> this value is the raw value of the GPIO line, but it should be the logical
>> value.
>
> I think we have a patch that already does this:
>
> http://www.kernelhub.org/?msg=390263&p=2
>
> Linus said it would be merged for 3.15, but I am not seeing it in -next. Linus?
>
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  drivers/gpio/gpiolib.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 4e10b10..111a1f1 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1751,6 +1751,9 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
>>                 return -EINVAL;
>>         }
>>
>> +       if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
>> +               value = !value;
>> +
>>         /* GPIOs used for IRQs shall not be set as output */
>>         if (test_bit(FLAG_USED_AS_IRQ, &desc->flags)) {
>>                 gpiod_err(desc,
>> --
>> 1.8.5.3
>>

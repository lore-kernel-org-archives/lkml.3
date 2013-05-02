Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3EBLs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:48:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34749 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3EBLsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130502112721.GA7309@the-dreams.de>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1365137521-31187-1-git-send-email-naveenkrishna.ch@gmail.com>
 <20130416102902.GE16978@the-dreams.de> <CAHfPSqCe_VJMeH3oCDc0CfcmpawMj0hN7_b3ngHDFtDUsPJLsA@mail.gmail.com>
 <CAHfPSqC0E42+-oRfLoFCEe6CbV08fJQdkagvVYHaer4pJAU6pg@mail.gmail.com> <20130502112721.GA7309@the-dreams.de>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 2 May 2013 17:18:31 +0530
Message-ID: <CAHfPSqC-7+dpJzKhdv8CP-9D+vfwy+uKm6Z9PL8puQK1PT6+=Q@mail.gmail.com>
Subject: Re: Fwd: [PATCH v7] i2c: exynos5: add High Speed I2C controller driver
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2013 16:57, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
>> >> +  - Samsung GPIO variant (deprecated):
>> >> +    - gpios: The order of the gpios should be the following: <SDA, SCL>.
>> >> +      The gpio specifier depends on the gpio controller.
>> >
>> > Huh? Why should we support a deprecated method with a new driver?
>> >
>
> This was left unanswered. I am curious.
This was a previous reply i sent out to public,
With my recent testing i can remove this deprecated method and use
pinctrl instead.
will be fixed in next revision.
>
>> >> +Optional properties:
>> >> +  - samsung,hs-mode: Mode of operation, High speed or Fast speed mode. If not
>> >> +    specified, default value is 0.
>> >> +  - samsung,hs-clock-freq: Desired operating frequency in Hz of the bus.
>> >> +    If not specified, the default value in Hz is 100000.
>> >> +  - samsung,fs-clock-freq: Desired operarting frequency in Hz of the bus.
>> >> +    If not specified, the default value in Hz is 100000.
>> >
>> > NACK! We have a generic binding for defining the bus speed. And
>> > shouldn't hs-mode be set depending on the bus speed?
>
> Please use "clock-frequency" here, like other drivers do.
I've tested this as well.
>
>> >> +     /* In auto mode the length of xfer cannot be 0 */
>> >> +     if (i2c->msg->len == 0)
>> >> +             i2c_auto_conf |= 0x1;
>> >
>> > So you send some byte then? Why not reject the message?
>> This is to support the probing the devices (i2cdetect cases)
>
> No! This is not a proper SMBUS_QUICK if you send a byte! If it doesn't
> work without sending data, then your device does not support it. This is
> not uncommon. Please check the smbus specs if you are unsure.
Ok, i will look into it, thanks for pointing out.
With this fix, the i2cdetect works for me though.
>
>> >> +     i2c->regs = of_iomap(np, 0);
>> >
>> > devm_ioremap_resource()
>> This was a comment from Thomas on v1.
>> https://lkml.org/lkml/2012/11/27/264
>>
>> Kindly, suggest me which one is more optimal in this case.
>
> "Optimal" is difficult here, but devm_* has momentum and I prefer
> consistency.
I've seen the rate of adaption for devm_* functions, have changed in
my local work.
>
>> Thanks for your valuable time and comments
>
> You're welcome! Thanks for the submission.
Thanks again.
Naveen
>
>    Wolfram
>



--
Shine bright,
(: Nav :)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3GVBTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:19:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41837 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3GVBTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:19:06 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: RE: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Topic: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Index: Ac6BzEn3Qmj4peQLTCahfY4cnCS0AwA0E7OAAPLQr5A=
Date: Mon, 22 Jul 2013 01:18:54 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E83161@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815C3@DQHE06.ent.ti.com>
 <20130717112033.GB3336@laptop>
In-Reply-To: <20130717112033.GB3336@laptop>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6M1JOm2006498

Hi Lee,
Thanks for your detailed review.

> > diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt
> b/Documentation/devicetree/bindings/mfd/lp3943.txt
> > new file mode 100644
> > index 0000000..4eb251d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
> > @@ -0,0 +1,23 @@
> > +Bindings for TI/National Semiconductor LP3943 Driver
> > +
> > +Required properties:
> > +  - compatible: "ti,lp3943"
> > +  - reg: 7bit I2C slave address. 0x60 ~ 0x67
> > +
> > +Optional properties:
> > +  - ti,pwm0, ti,pwm1: Output channel definition for PWM port 0 and 1
> > +                      0 = invalid, 1 = LED0, 2 = LED 1, ... 16 = LED15
>                                          No space here ^      ^ comma here
> 
> This is actually pretty confusing.

Thanks for catching this. my ugly formatting :(

> Any way you can put the invalid entry at the end so, 0 == LED0?
> 
> > +Datasheet
> > +  http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
> 
> Ah, I see.... So the above are pins, rather than arbitrary channel Nos.
> 
> Would it make sense to use pinctrl instead then?

I'm not familiar with the PINCTRL subsystem. I'll check it.

> > +int lp3943_read_byte(struct lp3943 *l, u8 reg, u8 *read)
> 
> Not sure I like 'l' as a variable name. The function is small enough
> to get away with it in this context, but it would probably be better
> if it were renamed to something more meaningful.

LP3943 consists of two devices - GPIO and PWM drivers.
So each private data was defined as 

struct lp3943 *l;			/* MFD device */
struct lp3943_gpio *lg;		/* GPIO driver */
struct lp3943_pwm *lp;		/* PWM driver */

As you pointed, the 'l' may look like a list of something.
I'll rename them as below.

struct lp3943 *lp3943;
struct lp3943_gpio *lp3943_gpio;
struct lp3943_pwm *lp3943_pwm;

> > +static const struct i2c_device_id lp3943_ids[] = {
> > +	{"lp3943", 0},
> 
> Lack of consistency ...

I don't know exactly what it means. Do you mean the name of I2C device?

Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

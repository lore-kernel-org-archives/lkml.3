Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaDFLMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 07:12:33 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:45112 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaDFLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 07:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAFRkauBRAmCpF+84bRhqB3hJinnt0apo4dpV+VfUELVXSr8+rg@mail.gmail.com>
References: <1396754381.13341.4.camel@phoenix>
	<20140406093053.GH12170@pengutronix.de>
	<CAFRkauBRAmCpF+84bRhqB3hJinnt0apo4dpV+VfUELVXSr8+rg@mail.gmail.com>
Date: Sun, 6 Apr 2014 13:12:30 +0200
Message-ID: <CAKSnaae5onmE4QnvTnN7TSC9iLb4DLaL561GMMsDwaPxzd8jTw@mail.gmail.com>
Subject: Re: [PATCH RFC] leds: pca9685: Remove leds-pca9685 driver
From: =?ISO-8859-1?Q?Maximilian_G=FCntner?= 
	<maximilian.guentner@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-06 12:40 GMT+02:00 Axel Lin <axel.lin@ingics.com>:
> 2014-04-06 17:30 GMT+08:00 Steffen Trumtrar <s.trumtrar@pengutronix.de>:
>> Hi!

Hello,

>> This confused me for a second, as there was no driver to replace when I wrote
>> the pwm-pca9685 driver and I thought I missed something. But it seems I didn't
>> and the pwm-pca9685 is actually older.
>
> Ah.. right, leds-pca9685 is a newer driver.
>
> 2013-10-22 leds: Added driver for the NXP PCA9685 I2C chip
> 2013-05-30 pwm: add pca9685 driver
>
True. I wrote this driver in April 2013 since there was no driver
available for the PCA9685 at this point.
When I submitted it in October I only checked 'drivers/leds/' for
support but not 'drivers/pwm'.

>>
>>> Use git grep to check current tree and found there is no user uses leds-pca9685.
>>> So this patch removes leds-pca9685 driver.
>>>
>>
>> If the platform setup is needed, maybe this can be integrated into the pwm driver
>> instead of completely dropping it. I don't care for platform code, but if someone
>> does, I don't want him to lose the support for it.
>
> Given the fact there is no user in current tree uses leds-pca9685,
> I suspect if we need to add platform setup to pwm-pca9685.
> ( I think the trend is to use DT, not the reverse )
>
>>
>> Otherwise I am okay with this drop (okay, I'm completely biased of course ;-)).
>> But technically the pca9685 is not solely a LED driver IC, but a PWM IC, so it
>> is in the wrong place anyhow.
>
> I also think PWM subsystem is better for this chip which is a PWM IC.
+1

I also ACK the drop of leds-pca9685 in favor of pwm-pca9685.

Thanks,

Maximilian

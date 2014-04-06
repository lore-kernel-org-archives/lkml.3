Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaDFKk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 06:40:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64507 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaDFKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 06:40:54 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.142.85]
In-Reply-To: <20140406093053.GH12170@pengutronix.de>
References: <1396754381.13341.4.camel@phoenix>
	<20140406093053.GH12170@pengutronix.de>
Date: Sun, 6 Apr 2014 18:40:53 +0800
Message-ID: <CAFRkauBRAmCpF+84bRhqB3hJinnt0apo4dpV+VfUELVXSr8+rg@mail.gmail.com>
Subject: Re: [PATCH RFC] leds: pca9685: Remove leds-pca9685 driver
From: Axel Lin <axel.lin@ingics.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        =?ISO-8859-1?Q?Maximilian_G=FCntner?= 
	<maximilian.guentner@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-06 17:30 GMT+08:00 Steffen Trumtrar <s.trumtrar@pengutronix.de>:
> Hi!
>
> On Sun, Apr 06, 2014 at 11:19:41AM +0800, Axel Lin wrote:
>> This driver is replaced by pwm-pca9685 driver and there is no user uses this
>> driver in current tree. So remove it.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>> Hi,
>> I found there is a modalias conflict between leds-pca9685.ko and pwm-pca9685.ko.
>> I think this conflict will cause problem.
>> After checking the code, I think leds-pca9685 is replaced by pwm-pca9685.
>
> This confused me for a second, as there was no driver to replace when I wrote
> the pwm-pca9685 driver and I thought I missed something. But it seems I didn't
> and the pwm-pca9685 is actually older.

Ah.. right, leds-pca9685 is a newer driver.

2013-10-22 leds: Added driver for the NXP PCA9685 I2C chip
2013-05-30 pwm: add pca9685 driver

>
>> Use git grep to check current tree and found there is no user uses leds-pca9685.
>> So this patch removes leds-pca9685 driver.
>>
>
> If the platform setup is needed, maybe this can be integrated into the pwm driver
> instead of completely dropping it. I don't care for platform code, but if someone
> does, I don't want him to lose the support for it.

Given the fact there is no user in current tree uses leds-pca9685,
I suspect if we need to add platform setup to pwm-pca9685.
( I think the trend is to use DT, not the reverse )

>
> Otherwise I am okay with this drop (okay, I'm completely biased of course ;-)).
> But technically the pca9685 is not solely a LED driver IC, but a PWM IC, so it
> is in the wrong place anyhow.

I also think PWM subsystem is better for this chip which is a PWM IC.

Thanks for the review,
Axel

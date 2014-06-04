Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaFDPGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:06:38 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41037 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaFDPGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140604144639.GI28484@ulmo>
References: <CACqcpZDziJs7QUKVYwio=La5LyRzBd+xeeRW=dPFcPzw0Wrn5Q@mail.gmail.com>
 <20140604144639.GI28484@ulmo>
From: =?UTF-8?Q?Rapha=C3=ABl_Poggi?= <raphio98@gmail.com>
Date: Wed, 4 Jun 2014 17:05:49 +0200
Message-ID: <CACqcpZBPMkpMvqpuZJSCi9yPH2GbTStL-8hQ-Fs7H9ORKCthtQ@mail.gmail.com>
Subject: Re: pwm: atmel: problem when disable pwm
To: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        inux-pwm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for your answer.

I'm seeing the problem with the version 3.10-at91. I tried with the
newer version of the driver which add the 916030db4399 commit and I
have the same bug.

2014-06-04 16:46 GMT+02:00 Thierry Reding <thierry.reding@gmail.com>:
> Adding in the linux-pwm mailing list.
>
> On Wed, Jun 04, 2014 at 02:56:13PM +0200, Raphaël Poggi wrote:
>> Hello,
>>
>> I'm using the pwm-atmel driver to control led, but i'm facing a problem.
>>
>> When writing "echo 0 > /sys/class/leds/d1/brightness" (to switch off
>> the led) sometimes the led stayed active.
>>
>> After investigation I think this problem is due to this function:
>>
>> static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> {
>>     struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>>
>>     atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
>>
>>     clk_disable(atmel_pwm->clk);
>> }
>>
>> By disable the pwm channel, I think the duty cycle "0" has not been
>> update, and the channel is disable and stayed in active state (high or
>> low depending of polarity).
>
> This sounds like a bug that could be fixed by this commit:
>
>         916030db4399 pwm: atmel: correct CDTY calculation
>
> What version of the kernel are you seeing this problem with? The above
> commit was first added in v3.15-rc1, so maybe try that or any later
> version to see if that fixes it.
>
> Thierry

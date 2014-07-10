Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaGJQRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:17:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54518 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaGJQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:17:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BEBC89.8080205@roeck-us.net>
Date: Thu, 10 Jul 2014 09:17:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: pwm-fan: Add pwm-fan driver
References: <1404917600-4430-1-git-send-email-k.debski@samsung.com> <20140709165817.GA24842@roeck-us.net> <107401cf9c52$1fe0a0e0$5fa1e2a0$%debski@samsung.com>
In-Reply-To: <107401cf9c52$1fe0a0e0$5fa1e2a0$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

On 07/10/2014 08:17 AM, Kamil Debski wrote:
>
>>
>>> +	}
>>> +
>>> +	dev_set_drvdata(&pdev->dev, ctx);
>>> +	platform_set_drvdata(pdev, ctx);
>>> +
>>> +	/* Set duty cycle to maximum allowed */
>>> +	ctx->duty_cycle = ctx->pwm->period - 1;
>>> +	ctx->pwm_value = MAX_PWM;
>>> +	pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);
>
> Guenter, I have a question regarding this. I see that gpio-fan reads
> the state of gpios and uses this as the initial setting.
> Led-pwm on init sets the brightness to LED_OFF.
>
> What should be the default state after init? Should the fan be off or
> at full power? I am thinking about adding an optional node to device
> tree that could be used to set this. But the question remains - what
> should be the default setting?
>

Trick question ... I can not really answer it. you can try the devicetree
option, but be prepared to have it rejected - the usual argument is that
dt shall only describe the HW but not its configuration.

Ultimately, either way is fine with me.

Guenter


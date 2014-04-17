Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaDQQoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:44:14 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:43836 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <534FA35B.6060005@nvidia.com>
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
	<534FA35B.6060005@nvidia.com>
Date: Thu, 17 Apr 2014 09:43:59 -0700
X-Google-Sender-Auth: T_6Ns5y6xO8EjuxZYbD4LbXAHyU
Message-ID: <CAL1qeaG+MBmBZ3dD6LZwV5mh5A=u+0N7Obt43UwhViaBYpXxpw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
From: Andrew Bresticker <abrestic@chromium.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 2:48 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Hi Andrew,
>
>
> On Wednesday 16 April 2014 06:55 AM, Andrew Bresticker wrote:
>>
>> diff --git a/drivers/pinctrl/pinctrl-as3722.c
>> b/drivers/pinctrl/pinctrl-as3722.c
>> index 92ed4b2..c862f9c0 100644
>> --- a/drivers/pinctrl/pinctrl-as3722.c
>> +++ b/drivers/pinctrl/pinctrl-as3722.c
>> @@ -64,7 +64,6 @@ struct as3722_pin_function {
>>   };
>>     struct as3722_gpio_pin_control {
>> -       bool enable_gpio_invert;
>>         unsigned mode_prop;
>>         int io_function;
>>   };
>
>
> Instead of removing this flag and  calling read of register on every gpio
> set, better if we update this flag on probe once and use this for entire
> life.

Because of regcache, the reads won't result in any additional I2C
transfers.  I can respin though if you want.

-Andrew

>
> So adding the code in probe() as
>
>         for (i = 0; i < ARRAY_SIZE(as3722_pingroups); ++i) {
>                 int gpio_cntr_reg = AS3722_GPIOn_CONTROL_REG(i);
>                 u32 val;
>
>                 ret = as3722_read(as3722, gpio_cntr_reg, &val);
>                 if (!ret)
> as_pci->gpio_control[i].enable_gpio_invert =
>                                         !!(val & AS3722_GPIO_INV);
>         }
>
>
> Thanks,
> Laxman

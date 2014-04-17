Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDQRYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:24:22 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3781 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDQRYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:24:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Apr 2014 10:16:23 -0700
Message-ID: <53500E3D.4040709@nvidia.com>
Date: Thu, 17 Apr 2014 22:54:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>	<534FA35B.6060005@nvidia.com> <CAL1qeaG+MBmBZ3dD6LZwV5mh5A=u+0N7Obt43UwhViaBYpXxpw@mail.gmail.com>
In-Reply-To: <CAL1qeaG+MBmBZ3dD6LZwV5mh5A=u+0N7Obt43UwhViaBYpXxpw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014 10:13 PM, Andrew Bresticker wrote:
> On Thu, Apr 17, 2014 at 2:48 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> Hi Andrew,
>>
>>
>> On Wednesday 16 April 2014 06:55 AM, Andrew Bresticker wrote:
>>> diff --git a/drivers/pinctrl/pinctrl-as3722.c
>>> b/drivers/pinctrl/pinctrl-as3722.c
>>> index 92ed4b2..c862f9c0 100644
>>> --- a/drivers/pinctrl/pinctrl-as3722.c
>>> +++ b/drivers/pinctrl/pinctrl-as3722.c
>>> @@ -64,7 +64,6 @@ struct as3722_pin_function {
>>>    };
>>>      struct as3722_gpio_pin_control {
>>> -       bool enable_gpio_invert;
>>>          unsigned mode_prop;
>>>          int io_function;
>>>    };
>>
>> Instead of removing this flag and  calling read of register on every gpio
>> set, better if we update this flag on probe once and use this for entire
>> life.
> Because of regcache, the reads won't result in any additional I2C
> transfers.  I can respin though if you want.

Yaah, if regcache is enabled on this then it will reduce i2c calls.

Just wanted to keep this invert bit so in future, if we need it, we can 
make it configurable. But not much issue here.

I am acking it
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>




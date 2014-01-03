Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbaACFFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:05:05 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58463 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaACFFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-L9RxRouoS=F8CywGW_s_tw4eZzLc4O0=_HdYtaMBVMuQ@mail.gmail.com>
References: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
	<CAK5ve-L9RxRouoS=F8CywGW_s_tw4eZzLc4O0=_HdYtaMBVMuQ@mail.gmail.com>
Date: Fri, 3 Jan 2014 10:35:02 +0530
Message-ID: <CAHbNUh3eC7dhEL9Ek4doGT-R=oPeMDm4N7dtE5fNSaXRKCz3mg@mail.gmail.com>
Subject: Re: [PATCH] leds: s3c24xx: Fix build failure
From: Tushar Behera <tushar.behera@linaro.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2014 04:12, Bryan Wu <cooloney@gmail.com> wrote:
> On Mon, Dec 30, 2013 at 1:09 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Fixes following build error.
>> drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
>> drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
>> function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]
>>
>
> I don't see any building error with s3c2410_defconfig. Actually this
> <plat/gpio-cfg.h> is included in
> arch/arm/mach-s3c24xx/include/mach/gpio.h which is in
> arch/arm/include/asm/gpio.h, then <linux/gpio.h>
>

This requires that CONFIG_NEED_MACH_GPIO_H is defined. Following
commit has removed this option for s3c24xx platform.

c67d0f29262b ("ARM: s3c24xx: get rid of custom <mach/gpio.h>").

-- 
Tushar Behera

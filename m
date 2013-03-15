Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3COLTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:19:17 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65114 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3COLTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130314140631.GM1906@pengutronix.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-12-git-send-email-fabio.porcedda@gmail.com>
 <201303141358.05616.arnd@arndb.de> <20130314140631.GM1906@pengutronix.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Fri, 15 Mar 2013 12:18:53 +0100
Message-ID: <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>,
        linux-input <linux-input@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 3:06 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Thu, Mar 14, 2013 at 01:58:05PM +0000, Arnd Bergmann wrote:
>> On Thursday 14 March 2013, Fabio Porcedda wrote:
>> > This patch converts the drivers to use the
>> > module_platform_driver_probe() macro which makes the code smaller and
>> > a bit simpler.
>> >
>> > Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > ---
>> >  drivers/misc/atmel_pwm.c  | 12 +-----------
>> >  drivers/misc/ep93xx_pwm.c | 13 +------------
>> >  2 files changed, 2 insertions(+), 23 deletions(-)
>>
>> The patch itself seems fine, but there are two issues around it:
>>
>> * The PWM drivers should really get moved to drivers/pwm and converted to the new
>>   PWM subsystem. I don't know if Hartley or Hans-Christian have plans to do
>>   that already.
>>
>> * Regarding the use of module_platform_driver_probe, I'm a little worried about
>>   the interactions with deferred probing. I don't think there are any regressions,
>>   but we should probably make people aware that one cannot return -EPROBE_DEFER
>>   from a platform_driver_probe function.

The use of module_platform_driver_probe() doesn't change anything about that,
it's exactly the same thing as using "return platform_driver_probe()".
I'm right or I'm missing something? Maybe are you just speaking about
the misuse of "platform_driver_probe"?

Best regards
Fabio Porcedda

>
> I'm worried about this aswell. I think platform_driver_probe shouldn't
> be used anymore. Even if a driver does not explicitly make use of
> -EPROBE_DEFER, it leaks in very quickly if a driver for example uses a
> regulator and just returns the error value from regulator_get.

> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

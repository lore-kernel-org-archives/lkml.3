Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3CRKDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:03:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35020 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3CRKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <201303152018.09094.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <201303141358.05616.arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F0020980106B9E@AUSP01VMBX24.collaborationhost.net>
 <201303152018.09094.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Mon, 18 Mar 2013 11:03:18 +0100
Message-ID: <CAHkwnC9YFTw8gVzyZB3_gZCgM5zMA6tLch15EDqcA2F4CAOpAQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 15 March 2013, H Hartley Sweeten wrote:
>> Arnd,
>>
>> Ill look at converting the ep93xx pwm driver to the PWM subsystem. The only issue is
>> the current driver exposes a sysfs interface that I think is not available in that subsystem.
>
> You can probably keep providing that interface if you have active users.
>
>> >* Regarding the use of module_platform_driver_probe, I'm a little worried about
>> >  the interactions with deferred probing. I don't think there are any regressions,
>> >  but we should probably make people aware that one cannot return -EPROBE_DEFER
>> >  from a platform_driver_probe function.
>>
>> The ep93xx pwm driver does not need to use platform_driver_probe(). It can be changed
>> to use module_platform_driver() by just moving the .probe to the platform_driver. This
>> driver was added before module_platform_driver() was available and I used the
>> platform_driver_probe() thinking it would save a couple lines of code.

Since by using platform_driver_probe() the  function
ep93xx_pwm_probe() is freed after initialization,
is better to use module_platform_drive_probe().
IMHO i don't see any good reason to use module_platform_driver() for
this driver.

Best regards
Fabio Porcedda

>> I'll change this in a bit. Right now I'm trying to work out why kernel 3.8 is not booting
>> on the ep93xx. I had 3.6.6 on my development board and 3.7 works fine but 3.8 hangs
>> without uncompressing the kernel.
>
> Ok, thanks!
>
>         Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3CRLUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:20:31 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61679 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3CRLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <201303181058.51641.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <201303152018.09094.arnd@arndb.de> <CAHkwnC9YFTw8gVzyZB3_gZCgM5zMA6tLch15EDqcA2F4CAOpAQ@mail.gmail.com>
 <201303181058.51641.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Mon, 18 Mar 2013 12:20:07 +0100
Message-ID: <CAHkwnC-aHwd24S5MyLhnVzTqqQj2L7MMuVX9dirhS-G830jZcw@mail.gmail.com>
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

On Mon, Mar 18, 2013 at 11:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 18 March 2013, Fabio Porcedda wrote:
>> Since by using platform_driver_probe() the  function
>> ep93xx_pwm_probe() is freed after initialization,
>> is better to use module_platform_drive_probe().
>> IMHO i don't see any good reason to use module_platform_driver() for
>> this driver.
>
> As I commented earlier, the platform_driver_probe() and
> module_platform_drive_probe() interfaces are rather dangerous in combination
> with deferred probing, I would much prefer Harley's patch.

Since those drivers don't use -EPROBE_DEFER i was thinking that they don't use
deferred probing.
I'm missing something?

Best regards
Fabio Porcedda

>         Arnd

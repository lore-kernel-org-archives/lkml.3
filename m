Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab3CSJEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:04:36 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:47199 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3CSJEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkwnC9fg7_uhLM2KD3vvj_oFx3EBoQfw8mCN=V9pyV5=k37aA@mail.gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
	<201303181058.51641.arnd@arndb.de>
	<CAHkwnC-aHwd24S5MyLhnVzTqqQj2L7MMuVX9dirhS-G830jZcw@mail.gmail.com>
	<201303181128.45215.arnd@arndb.de>
	<CAHkwnC9fg7_uhLM2KD3vvj_oFx3EBoQfw8mCN=V9pyV5=k37aA@mail.gmail.com>
Date: Tue, 19 Mar 2013 10:04:32 +0100
X-Google-Sender-Auth: T5yuHLgO8-IYjR2X8VK1HbbZwR0
Message-ID: <CAMuHMdVS56HRDSvr7XCpVEjEWnGti+V=J_m4qQzEid=23ON_fQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabio Porcedda <fabio.porcedda@gmail.com>, Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 9:55 AM, Fabio Porcedda
<fabio.porcedda@gmail.com> wrote:
> On Mon, Mar 18, 2013 at 12:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Monday 18 March 2013, Fabio Porcedda wrote:
>>> On Mon, Mar 18, 2013 at 11:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> > On Monday 18 March 2013, Fabio Porcedda wrote:
>>> >> Since by using platform_driver_probe() the  function
>>> >> ep93xx_pwm_probe() is freed after initialization,
>>> >> is better to use module_platform_drive_probe().
>>> >> IMHO i don't see any good reason to use module_platform_driver() for
>>> >> this driver.
>>> >
>>> > As I commented earlier, the platform_driver_probe() and
>>> > module_platform_drive_probe() interfaces are rather dangerous in combination
>>> > with deferred probing, I would much prefer Harley's patch.
>>>
>>> Since those drivers don't use -EPROBE_DEFER i was thinking that they don't use
>>> deferred probing.
>>> I'm missing something?
>>
>> clk_get() may return -EPROBE_DEFER after ep93xx is converted to use the
>> common clk API. We currently return the value of clk_get from the probe()
>> function, which will automatically do the right thing as long as the probe
>> function remains reachable.
>
> Thanks for the explanation.

Hmm, so we may have drivers that (now) work perfectly fine with
module_platform_driver_probe()/platform_driver_probe(), but will start
failing suddenly in the future?

I guess we need a big fat WARN_ON(-EPROBE_DEFER) in
platform_driver_probe() to catch these?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

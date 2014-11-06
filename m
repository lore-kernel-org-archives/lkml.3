Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaKFL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:27:47 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:60893 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKFL1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:27:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141106112244.GM1618@lahna.fi.intel.com>
References: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
	<545843B1.3020101@nvidia.com>
	<2455157.3p7mHhT8im@vostro.rjw.lan>
	<CAMuHMdXn9W2S7N+YGfjDxQozMtRZCVdTzzdDps6YfOv2FqVBmw@mail.gmail.com>
	<20141106103033.GK1618@lahna.fi.intel.com>
	<CAMuHMdWtcZcpW=r60s9auENZxChiLwr14R0p_soKr7C3yGYOMQ@mail.gmail.com>
	<20141106105855.GL1618@lahna.fi.intel.com>
	<CAMuHMdUroLo5SdXrTu+etiW+TwHAWV-Qn9UsVnud+BJ7q6nXjw@mail.gmail.com>
	<20141106112244.GM1618@lahna.fi.intel.com>
Date: Thu, 6 Nov 2014 12:27:42 +0100
X-Google-Sender-Auth: VF6QbXaKLTj1OK2aeV9fqUvhaLA
Message-ID: <CAMuHMdVA=L22R=gDJBHcgGbD5tsTOPpVZHaxeLsaB+mXhQswVg@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 12:22 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Nov 06, 2014 at 12:12:04PM +0100, Geert Uytterhoeven wrote:
>> On Thu, Nov 6, 2014 at 11:58 AM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > On Thu, Nov 06, 2014 at 11:32:19AM +0100, Geert Uytterhoeven wrote:
>> >> On Thu, Nov 6, 2014 at 11:30 AM, Mika Westerberg
>> >> <mika.westerberg@linux.intel.com> wrote:
>> >> >> "leds: leds-gpio: Add support for GPIO descriptors" broke leds-gpio on
>> >> >> non-DT platforms for me:
>> >> >>
>> >> >>     gpiod_direction_output: invalid GPIO
>> >> >>     leds-gpio: probe of leds-gpio failed with error -22
>> >> >>
>> >> >> (desc is NULL in gpiod_direction_output()).

>>     leds-gpio leds-gpio: GPIO 102, ret: 0
>>     leds-gpio leds-gpio: GPIOD: c050e970
>>
>> So led_dat is non-NULL. But it's overwritten by NULL later:
>>
>>     led_dat->gpiod = template->gpiod;
>
> Ah, that's it. Nice catch!
>
>> Whitespace damaged fix below, to fold into the original.
>> If you prefer a proper separate patch, let me know.
>
> It is up to Rafael. I think he wants to stabilize this branch so in that
> case separate patch on top would work better.

I've already sent a patch, as I have to publish the fix in my git tree anyway.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

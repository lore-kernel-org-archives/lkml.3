Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaK3LzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:55:25 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55842 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaK3LzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:55:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
Date: Sun, 30 Nov 2014 12:54:43 +0100
Message-ID: <3198130.fuxnzyHmMt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <f8bc59dd2c2d20c8fc9f49ec354ac474@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch> <18555848.LVhqYu0kXL@wuerfel> <f8bc59dd2c2d20c8fc9f49ec354ac474@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JszVmLs5TiHNArOpw9hx5Eaqzos8woUtqTY+ddF86hh
 jpIWMd2eaUmEFbHtIvNe/jaFsHFznxJPkQ3jTaGCxotZaWhD3x
 CTenucmStCX6sKvOS+JJ19EMS8ki5sFTp7ICMws/uViBltIktT
 QdXdHuiDvd48fQTvs6dLTnmAaBNUGfdNP48PKyxTbrpewB5E6u
 MuciSOT66YmRGNzPBq0WvlokXfJKWwXZF/e783N38SzjG3xdS0
 Rn47tuMOTApx0qrSM/ZLBFshxlHZkLitEa3gfBd07/Z4S6VN/J
 rSbVKEEaQKb8gCR+Y9MTHk0GBFgTwMeC1k0gXIVXjGNz5kq3Ov
 JCeuB2ZBarjlraVx4b1Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2014 01:15:57 Stefan Agner wrote:
> On 2014-11-28 23:22, Arnd Bergmann wrote:
> > On Friday 28 November 2014 23:09:09 Stefan Agner wrote:
> >> On 2014-11-28 22:24, Arnd Bergmann wrote:
> >> > On Friday 28 November 2014 22:02:01 Stefan Agner wrote:
> >> >
> >> >> > If the SRC is also capable of resetting individual blocks instead of just
> >> >> > the entire machine, it would be a reset driver in drivers/reset instead.
> >> >>
> >> >> Beside the system reset, there is only a mask functionality for the
> >> >> watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
> >> >> M4). This makes the SRC module in the Vybrid a bit different then what
> >> >> is available on other i.MX SoC's...
> >> >
> >> > If you already have the watchdog registers in there and want to have
> >> > a watchdog driver too, the easiest way would be to register the reboot
> >> > handler from the watchdog driver.
> >>
> >> Hm, not sure we speak about the same here. The SRC module has two
> >> (multi-)bit fields to mask the watchdog reset event for each watchdog.
> >> Beside that, there are two full watchdog register maps, which are in
> >> different areas. There is already a driver for this watchdogs. I'm not
> >> sure what the idea behind this is exactly, I guess it would easily allow
> >> to (temporary) mask the other CPU's watchdog. However, I don't think we
> >> need that functionality, so I don't care about that right now.
> > 
> > Ok, I see, thanks for the clarification!
> > 
> >> There is also a restart handler in the watchdog driver, but I prefer to
> >> use the reset capabilities of the SRC since it has immediate effect.
> >>
> >> Lets get to the big picture again: I could register the whole SRC
> >> register map as a syscon device and then access the registers from my
> >> suspend/resume implementation later on. And similar in the restart
> >> driver, I would use syscon_regmap_lookup_by_compatible to check if it
> >> contains the vf610-src compatible string and register the restart
> >> driver/handler if available.
> 
> One thing which came into my mind regarding suspend: I might need to
> access the registers from assembler (in SRAM), can I do that through
> syscon/regmap? I had a quick look, but I don't found a way to get back
> the mapped IO base address.. By good reasons, of course, for most
> applications. But in my case, afaik I have no other choice.

Yes, I can see that being a problem. What register specifically do
you need to access from code running in SRAM?

	Arnd

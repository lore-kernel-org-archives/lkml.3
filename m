Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaK1WXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:23:05 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55603 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:23:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
Date: Fri, 28 Nov 2014 23:22:57 +0100
Message-ID: <18555848.LVhqYu0kXL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6341b31998ff843d236bc2a3e34537b0@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch> <2716009.DOfHfaSPkY@wuerfel> <6341b31998ff843d236bc2a3e34537b0@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OfWiSOJRuRiYt2grqFtM2ODglCA1DL2PEtDCv7pSbEM
 UyM+pzIMgRnTUX3RJJyPLD8EHckNP0QgWqHFRCSjVlTMRUKUs3
 tIl+I56YJWDtnnpV9g6B/83B9TpwDn4CCxIAXEH1MFaxLvBKA8
 RT2sSaMDiqgTTyPL15I8/g0o+2LONHKN/jWChbGz2xqLhbkhUy
 17YrjT1j21iAG8HpFs+/BOVds3Qqld4Z8hkTMpbVtpxO2Cip2I
 BHPIccZBaqMNlRKjBTT54JbXOb2kJlpbNPVqR8rmVu0BYeYCQ3
 /VH2xOc6OcHyP1av1tjYNwokVh8jrK/G5vWG2qUwW10Hg/dnVN
 3w3+KQJ7xaWJjyN1096k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 23:09:09 Stefan Agner wrote:
> On 2014-11-28 22:24, Arnd Bergmann wrote:
> > On Friday 28 November 2014 22:02:01 Stefan Agner wrote:
> > 
> >> > If the SRC is also capable of resetting individual blocks instead of just
> >> > the entire machine, it would be a reset driver in drivers/reset instead.
> >>
> >> Beside the system reset, there is only a mask functionality for the
> >> watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
> >> M4). This makes the SRC module in the Vybrid a bit different then what
> >> is available on other i.MX SoC's...
> > 
> > If you already have the watchdog registers in there and want to have
> > a watchdog driver too, the easiest way would be to register the reboot
> > handler from the watchdog driver.
> 
> Hm, not sure we speak about the same here. The SRC module has two
> (multi-)bit fields to mask the watchdog reset event for each watchdog.
> Beside that, there are two full watchdog register maps, which are in
> different areas. There is already a driver for this watchdogs. I'm not
> sure what the idea behind this is exactly, I guess it would easily allow
> to (temporary) mask the other CPU's watchdog. However, I don't think we
> need that functionality, so I don't care about that right now.

Ok, I see, thanks for the clarification!

> There is also a restart handler in the watchdog driver, but I prefer to
> use the reset capabilities of the SRC since it has immediate effect. 
> 
> Lets get to the big picture again: I could register the whole SRC
> register map as a syscon device and then access the registers from my
> suspend/resume implementation later on. And similar in the restart
> driver, I would use syscon_regmap_lookup_by_compatible to check if it
> contains the vf610-src compatible string and register the restart
> driver/handler if available.

Correct, and also in the watchdog driver, I guess.

Instead of syscon_regmap_lookup_by_compatible, please use
syscon_regmap_lookup_by_phandle and put the link to the syscon
device into the device accessing it.

Also, see if you can use or extend drivers/power/reset/syscon-reboot.c
for your use case.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3ANKUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:20:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10880 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3ANKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:20:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 Jan 2013 02:19:21 -0800
Message-ID: <50F3DC2B.6000603@nvidia.com>
Date: Mon, 14 Jan 2013 19:21:31 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        <gnurou@gmail.com>, <linux-m68k@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301091046.13020.arnd@arndb.de> <2270940.DTxEYMZtED@percival> <201301101008.45091.arnd@arndb.de>
In-Reply-To: <201301101008.45091.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 07:08 PM, Arnd Bergmann wrote:
> I've tried to find platforms that don't yet use GPIOLIB and fortunately
> there are very few left:
>
> I found two that provide the generic gpio interfaces when gpiolib
> is disabled, but use gpiolib otherwise for the same hardware,
> arch/m68k/include/asm/mcfgpio.h and arch/blackfin/include/asm/gpio.h.
> I would assume that we can simply remove the non-gpiolib shortcut
> here at cost of a small overhead.

I performed a search on my side too (checking configurations options 
which select GENERIC_GPIO but not ARCH_REQUIRE_GPIOLIB) and found the 
same list. This takes some time btw - many platforms use this combo to 
make GPIO support optional. Can I ask how you figured out these two archs?

I'd assume the overhead induced by forcibly compiling GPIOlib is 
neglectable, but let's make sure this is ok indeed - Mike, Geert, would 
you mind if selecting GENERIC_GPIO enforced GPIOlib to be compiled in, 
effectively making it mandatory to implement the generic GPIO interface 
using GPIOlib? Both your implementations support GPIOlib already, but 
can also work without it, and that would make that possibility obsolete.

> Then there are a bunch that use gpiolib but have a nontrivial
> implementation of gpio_get_value and other functions. I'm not sure
> if these are a problematic with your code.

AFAICT these all implement an inline path that bypasses GPIOlib when the 
GPIO number is known at compile time, for faster bitbanging I presume. 
It should be totally harmless to keep them. Unfortunately, I don't think 
it would be possible to have a similar trick using handlers.

Thanks,
Alex.

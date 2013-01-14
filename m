Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3ANKqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:46:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3ANKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:46:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Mon, 14 Jan 2013 10:46:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        gnurou@gmail.com, linux-m68k@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301101008.45091.arnd@arndb.de> <50F3DC2B.6000603@nvidia.com>
In-Reply-To: <50F3DC2B.6000603@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141046.12976.arnd@arndb.de>
X-Provags-ID: V02:K0:ajd6tcuv8jgSuvGSBsZ63Ii6EPr9CJmCpMf4u7PwK+j
 yn0QmALdn1q9ct2rKPheEwIm7ulJ9VN4J3TfBfUpulOz/zzCzJ
 U7kYrH+fA/JLpH7UyydKh2cYXWN4xBAOVTgbBMw2s40vAii+g0
 ehmTayhy57xEAXDZ3z5LNUI8bly+fq+8qRYJBAJEdq/VcnrsC3
 veZ04iXCa8xX9GkHqNI9NiCgX08VZXhoyBPz1oVC1j0xura0Ie
 /hFnTwA1ZlSlFbUeHats/hU4SBjo5CRxfgs5BN7/krjR0r/oq9
 U0N9YRvn3piWKCQt/Ee3bk7WJbM+hFK8ahtBvWVAjmf1DzYiGG
 I9xdwNtshQyOhC09wfX8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013, Alex Courbot wrote:
> On 01/10/2013 07:08 PM, Arnd Bergmann wrote:
> > I found two that provide the generic gpio interfaces when gpiolib
> > is disabled, but use gpiolib otherwise for the same hardware,
> > arch/m68k/include/asm/mcfgpio.h and arch/blackfin/include/asm/gpio.h.
> > I would assume that we can simply remove the non-gpiolib shortcut
> > here at cost of a small overhead.
> 
> I performed a search on my side too (checking configurations options 
> which select GENERIC_GPIO but not ARCH_REQUIRE_GPIOLIB) and found the 
> same list. This takes some time btw - many platforms use this combo to 
> make GPIO support optional. Can I ask how you figured out these two archs?

I basically grepped for GENERIC_GPIO and looked at
the individual implementations.

> > Then there are a bunch that use gpiolib but have a nontrivial
> > implementation of gpio_get_value and other functions. I'm not sure
> > if these are a problematic with your code.
> 
> AFAICT these all implement an inline path that bypasses GPIOlib when the 
> GPIO number is known at compile time, for faster bitbanging I presume. 
> It should be totally harmless to keep them. Unfortunately, I don't think 
> it would be possible to have a similar trick using handlers.

Right, makes sense.

	Arnd

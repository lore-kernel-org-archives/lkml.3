Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaIHJwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:52:49 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52535 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:52:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2
Date: Mon, 08 Sep 2014 11:52:35 +0200
Message-ID: <26517543.McM8Q5P0vn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140908092642.GB20883@lukather>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com> <201409052325.11709.arnd@arndb.de> <20140908092642.GB20883@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hi3o3Mjku21Xbq8hK1nKctFB1BMOq4Jnh0qVKmTNyKj
 WDaYd6iYN0gQkhEjPaLHCio0C/c7xRsN97pgAEsKjae+R12i0V
 RujjY8LLzpS6Pe9nq2X58CcvOX2XBVi3cGpLiOct0HOA5mQLDt
 85m82N8LTQUgEvgdSke0OdVANpL7NC2/LyznNsbSvuoaqr54si
 BjEpDxk4RT1uqh4YIyt0cQSOkrwlif1waGWsN0MOF08K2oNal1
 7Zp9PABbOWYyA2v5COWsPzOmYtkqMHiZcn3xvxMluMMbWV3NRy
 DJdsL0zZELc98cVUZnOlfuFDO4oZwNdaTYSz/cGVaJKPKSB9M0
 9GPR6WI7LJkCLtu8KmvM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 11:26:42 Maxime Ripard wrote:
> On Fri, Sep 05, 2014 at 11:25:11PM +0200, Arnd Bergmann wrote:
> > On Friday 05 September 2014, Nicolas Ferre wrote:
> > > Arnd, Olof, Kevin,
> > > 
> > > This pull-request is focused on the work that Maxime did for migrating our timer
> > > (PIT) to the clocksource sub-system. A big cleanup happened which allows us to
> > > be even closer to the point when we have only the bare minimum in our formerly
> > > crowded mach-at91 directory.
> > > 
> > > This pull-request goes on top of the "drivers" one already sent to you on Sept.
> > > 01st.
> > 
> > Hmm, I'm not too happy to see more uses of early_platform_*, I was hoping
> > we could kill that off in the long run. This is only used for the legacy
> > board files, not for DT, right?
> 
> Yes, the DT uses the usual CLOCKSOURCE_OF_DECLARE mechanism.
> 
> I wasn't aware that early_platform drivers were in the killzone, but
> I'm definitely aware that global custom exported functions are, hence
> why I went this way.

I don't think it has been discussed much on the mailing list or IRC.
The early platform devices have not been used much outside of arch/sh
and arch/arm/mach-shmobile, and those only use it for clocksource and
serial.

Now we have a new method for both of these, at least with DT, so
my impression is that we won't need the early_platform support in
the future. One of the problems with the current interface is that
it requires statically declaring platform_device structures, which is
something that has been on Greg's list of device model antipatterns
for a long time.

> > Do you have a timeline for getting rid of the board files completely?
> 
> I don't, but it would be great if we could kill these in the next
> couple releases.

Ok, good.

	Arnd

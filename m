Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaIEVkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:40:00 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52248 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIEVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:39:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2
Date: Fri, 05 Sep 2014 23:39:17 +0200
Message-ID: <4063119.0hOqm7cf3h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201409052325.11709.arnd@arndb.de>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com> <201409052325.11709.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e4958EYuoVze5BBi44LOfX44nzx5TPEfJ7leknrSjCs
 4gy18nDMVWWiPZVG4xGPSmNgUcNQHH+zRSoCGNridfbKLvFjXv
 QnN/zvgW3Px+YmAE+j3VoZDUHGbIgwiOIPh43GsnQL376/91tu
 KdR63w/VxC+oQoRsplM59FecK+dbvKcUyr8Az98nfhtu5e3Pdk
 EWtFK4pqC7YbqeGcOEDVPoyfXgqoS9JHgsW+B1KMAvZRP9Nuon
 bRsgLHwOZ6Bbgyu+If/t0DmV69m9og571KBkPG4mPYB8G7Cs3P
 jqT1aY7Ev4XeBLlm4+Cqi8soRJ+mX2JvBqEmw6N9YgXsCdE2Py
 95TDmB5sj8PjGrJasamY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 23:25:11 Arnd Bergmann wrote:
> On Friday 05 September 2014, Nicolas Ferre wrote:
> > Arnd, Olof, Kevin,
> > 
> > This pull-request is focused on the work that Maxime did for migrating our timer
> > (PIT) to the clocksource sub-system. A big cleanup happened which allows us to
> > be even closer to the point when we have only the bare minimum in our formerly
> > crowded mach-at91 directory.
> > 
> > This pull-request goes on top of the "drivers" one already sent to you on Sept.
> > 01st.
> 
> Hmm, I'm not too happy to see more uses of early_platform_*, I was hoping
> we could kill that off in the long run. This is only used for the legacy
> board files, not for DT, right?
> 
> Do you have a timeline for getting rid of the board files completely?
> 

I've looked more closely, and I think a good way to solve this would be
to revert or remove "ARM: at91: PIT: Convert to an early_platform_device",
and add declarations for the two global functions to
include/clocksource/at91.h and passing the interrupt number as an argument
to at91sam926x_pit_init.

I understand it's not the goal you had in mind here, but it's far simpler
and it gives me hope that we can eventually kill that early platform
code.

	Arnd

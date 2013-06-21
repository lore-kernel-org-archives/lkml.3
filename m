Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab3FUOAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:00:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030372Ab3FUOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:00:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <agnel.joel@gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Fri, 21 Jun 2013 16:00:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sekhar Nori <nsekhar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <51C427E1.2000800@ti.com> <CAD=GYpb54bitcg0gnfhzxbvig3etRPY6fs=FOQu5nYkio5NRZw@mail.gmail.com>
In-Reply-To: <CAD=GYpb54bitcg0gnfhzxbvig3etRPY6fs=FOQu5nYkio5NRZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211600.04986.arnd@arndb.de>
X-Provags-ID: V02:K0:6tRB0V+U/W1q2nKY0PGajkBZFt5LHwwX2NsHWczybOS
 ECWinBZp3vVNwgpM+o7/JSFM4isqxq04oqW/4+HCqsAJMQJZH2
 qC9L5nrMnUig0PWNoukLd3IGLjQVIYz8u2RfpS41xrVlCHQdzN
 KR4TfsY2QRf+Ef7vyAK1Som6D/Q3hHj3VvBTxq4Im/C80ic7TK
 WIIKnQBBGQN0O9XkudoqRoKpcTSed75zGl39P9R16+S8BL9y99
 BtsR5QVnAd3xxmDk4EJ4uVM26HRoEPClY0XlsKDukZtw8M5/2b
 quxdV4hBKBQth1RWk2HZXh8wgxQe/J8PPdJbRV274J7Qck2e7B
 FpRod9eMoDZYgsSJ8zck=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Joel A Fernandes wrote:
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index b1c66a4..7d58cd9 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -841,6 +841,7 @@ config ARCH_DAVINCI
> >>       select HAVE_IDE
> >>       select NEED_MACH_GPIO_H
> >>       select TI_PRIV_EDMA
> >> +     select DMADEVICES
> >
> > It is generally a bad idea to force select on something that can be
> > enabled using menuconfig. Unless used carefully, select causes "unmet
> > direct dependency" warnings which folks are already fighting hard to
> > fix. This leads to what Russell referred in the past as "select madness" [1]
> 
> Are you concerned with bloat issues? I know your point of view but the idea
> was to build these options by default for these platforms even though
> in some cases
> it might not be used. I have seen folks including myself select the wrong
> option. Having the build system automatically select the correct option for the
> most common cases can be very useful I feel and not require manual
> configuration.

For defaults, you should use the defconfig, not 'select' in Kconfig.

A lot of the 'select' statements are actually wrong because they
do not take dependencies into account where A selects B but not C,
and B depends on C, which leads to broken builds when C is disabled
by a user (or randconfig).

You should only ever use 'select' from platforms on silent options
that are not themselves user selectable like the above 'HAVE_IDE'
and 'NEED_MACH_GPIO_H'.

	Arnd

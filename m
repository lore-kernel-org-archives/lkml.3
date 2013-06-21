Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945931Ab3FUSkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:40:51 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43822 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <201306211632.12577.arnd@arndb.de>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<201306211600.04986.arnd@arndb.de>
	<CAD=GYpZ_5Lp1La=f+2BQfmuj+sc3FgygZRD4gfj4JGGZ0Do=_Q@mail.gmail.com>
	<201306211632.12577.arnd@arndb.de>
Date: Fri, 21 Jun 2013 13:40:48 -0500
Message-ID: <CAD=GYpbhBAaSkMtcJaPtVpWar7AcW37QpAk3A0qgwX6G5PDoZg@mail.gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 9:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 21 June 2013, Joel A Fernandes wrote:
>> I haven't come across this problem but- are you saying there is a
>> shortcoming in Kbuild/Kconfig that selects an option even if its
>> dependency is not met?
>
> Well, the shortcoming is that it lets you specify impossible
> contraints. You get a warning from Kconfig when building
> such a configuration, but then it continues.
>
>> The problem with defconfig is also too many options I feel for a common case.
>> CONFIG_DMADEVICES=y
>> CONFIG_TI_EDMA=y
>>
>> Most if not all future OMAPs from will use EDMA. Why not we can be
>> explicit about it and just built it in anyway. If ARCH_OMAP and
>> DMADEVICES are selected, then we can just build EDMA in by default.
>
> It's just not how we do things. Kconfig is a mess because we are
> not consistent in the way this is done.
>
>> I agree maybe the option can be dropped from Davinci but I suggest
>> let's keep it for OMAP. Is that ok?
>
> No, I would still like you to not add it to either one. I'm spending
> a lot of my time tracking down incorrect 'select' statements and I'd
> rather spend it in a different way. I've had to a number of 'select'
> statements from OMAP in the past, please don't add any new ones
> unless there is a strict build dependency (which normally should not
> exist).

I think we are talking about different things, I agree the 'select
DMADEVICES' can be dropped but lets please keep the default y option
(not adding new select statements, just saying that if someone select
DMADEVICES in menuconfig and if they're ARCH_OMAP=1 , then default to
EDMA). This will simply allow people to have a default. Thanks.

Thanks
Joel

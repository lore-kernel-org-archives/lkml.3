Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422974Ab3FUOUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:20:05 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34357 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422901Ab3FUOUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <201306211600.04986.arnd@arndb.de>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<51C427E1.2000800@ti.com>
	<CAD=GYpb54bitcg0gnfhzxbvig3etRPY6fs=FOQu5nYkio5NRZw@mail.gmail.com>
	<201306211600.04986.arnd@arndb.de>
Date: Fri, 21 Jun 2013 09:20:01 -0500
Message-ID: <CAD=GYpZ_5Lp1La=f+2BQfmuj+sc3FgygZRD4gfj4JGGZ0Do=_Q@mail.gmail.com>
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

On Fri, Jun 21, 2013 at 9:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 21 June 2013, Joel A Fernandes wrote:
>> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> >> index b1c66a4..7d58cd9 100644
>> >> --- a/arch/arm/Kconfig
>> >> +++ b/arch/arm/Kconfig
>> >> @@ -841,6 +841,7 @@ config ARCH_DAVINCI
>> >>       select HAVE_IDE
>> >>       select NEED_MACH_GPIO_H
>> >>       select TI_PRIV_EDMA
>> >> +     select DMADEVICES
>> >
>> > It is generally a bad idea to force select on something that can be
>> > enabled using menuconfig. Unless used carefully, select causes "unmet
>> > direct dependency" warnings which folks are already fighting hard to
>> > fix. This leads to what Russell referred in the past as "select madness" [1]
>>
>> Are you concerned with bloat issues? I know your point of view but the idea
>> was to build these options by default for these platforms even though
>> in some cases
>> it might not be used. I have seen folks including myself select the wrong
>> option. Having the build system automatically select the correct option for the
>> most common cases can be very useful I feel and not require manual
>> configuration.
>
> For defaults, you should use the defconfig, not 'select' in Kconfig.
>
> A lot of the 'select' statements are actually wrong because they
> do not take dependencies into account where A selects B but not C,
> and B depends on C, which leads to broken builds when C is disabled
> by a user (or randconfig).

I haven't come across this problem but- are you saying there is a
shortcoming in Kbuild/Kconfig that selects an option even if its
dependency is not met?

The problem with defconfig is also too many options I feel for a common case.
CONFIG_DMADEVICES=y
CONFIG_TI_EDMA=y

Most if not all future OMAPs from will use EDMA. Why not we can be
explicit about it and just built it in anyway. If ARCH_OMAP and
DMADEVICES are selected, then we can just build EDMA in by default.

I agree maybe the option can be dropped from Davinci but I suggest
let's keep it for OMAP. Is that ok?

Thanks,
Joel

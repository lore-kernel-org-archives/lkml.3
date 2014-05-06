Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaEFSMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:12:46 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56193 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaEFSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:12:45 -0400
Date: Tue, 6 May 2014 11:12:40 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v2 02/12] ARM: defconfigs: add MTD_SPI_NOR (new
 dependency for M25P80)
Message-ID: <20140506181240.GC28907@ld-irv-0074>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
 <1398925607-7482-3-git-send-email-computersforpeace@gmail.com>
 <20140501085447.GB20410@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501085447.GB20410@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 05:54:47PM +0900, Simon Horman wrote:
> [ CC linux-sh and Magnus Damm (shmobile co-maintainer) ]
> 
> On Wed, Apr 30, 2014 at 11:26:37PM -0700, Brian Norris wrote:
> > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> > the new dependency.
> > 
> > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> > 
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> > This patch catches all the configs I couldn't find a sub-arch for, plus the ARM
> > multiplatform defconfigs
> > 
> >  arch/arm/configs/bockw_defconfig    | 2 +-
> >  arch/arm/configs/koelsch_defconfig  | 1 +
> >  arch/arm/configs/lager_defconfig    | 1 +
> 
> The above changes are for shmobile SoC defconfigs which I maintain
> (as is one other patch in the series).
> While the below ones are not.

This is admittedly a confusing process. I have to parse each defconfig
to figure out what the mach-* is, then read MAINTAINERS. Perhaps you can
update your MAINTAINERS entries? This is a wide problem, that makes
patch submission for defconfigs even more difficult.

Olof, other ARM SOC maintainers,

What do you recommend? Should I send another couple of patches just to
split this trivial patch? Olof mentioned taking some patch(es) directly,
and handling merge conflicts when they come.

> With regards to updating shmobile configuration options,
> we have recently moved towards using Kconfig rather than
> defconfig in cases where selecting A means we really ought
> to select B too. Something along the lines of:
> 
> 	select CONFIG_MTD_SPI_NOR if CONFIG_MTD_M25P80

That seems like you're just avoiding touching defconfig for the sake of
not touching defconfig. Additionally, this method only really makes
sense for an upgrade path (otherwise, how would you configure MTD_M25P80
&& !MTD_SPI_NOR?). Is this approach consistent across other mach-*?

> Do you consider that CONFIG_MTD_SPI_NOR should always
> be selected if CONFIG_MTD_M25P80 if selected?

Yes. That's what "depends on" means.

BTW, M25P80 will likely be moved under the SPI-NOR submenu eventually
(its driver is not really a "Standalone MTD" anymore), but currently
this is just a "depends on".

> If so, perhaps it would be best to update the CONFIG_MTD_M25P80 Kconfig
> node to select CONFIG_MTD_M25P80. This would probably imply that most
> if not all of this series would no longer be needed.

I do not understand this paragraph. How does M25P80 select M25P80?

> If not, would you be able to make a patch to add something like
> the above snippet to arch/arm/shmobile/Kconfig (probably more than once)
> and drop the changes to shmobile defconfigs from this series?

Feel free to submit your own patch if you don't want mine.

> >  arch/arm/configs/multi_v5_defconfig | 1 +
> >  arch/arm/configs/multi_v7_defconfig | 1 +
> >  5 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/configs/bockw_defconfig b/arch/arm/configs/bockw_defconfig
> > index e816140d81c5..28339e072a71 100644
> > --- a/arch/arm/configs/bockw_defconfig
> > +++ b/arch/arm/configs/bockw_defconfig
> > @@ -50,11 +50,11 @@ CONFIG_DEVTMPFS_MOUNT=y
> >  # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> >  # CONFIG_FW_LOADER is not set
> >  CONFIG_MTD=y
> > -CONFIG_MTD_CHAR=y
> 
> The above change seems unrelated to the subject of the patch.
> 
> If its valid then I'd prefer it submitted as a separate patch.

Seriously? It's mentioned in the commit description, and it's really
really trivial.

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbaIPAXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:23:46 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37076 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbaIPAXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:23:43 -0400
Date: Tue, 16 Sep 2014 09:23:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nishanth Menon <nm@ti.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / OPP: Remove ARCH_HAS_OPP completely
Message-ID: <20140916002333.GI9847@verge.net.au>
References: <1406551632.5397.17.camel@x220>
 <1410511111.31130.4.camel@x220>
 <20140916000916.GD9847@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916000916.GD9847@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 09:09:17AM +0900, Simon Horman wrote:
> On Fri, Sep 12, 2014 at 10:38:31AM +0200, Paul Bolle wrote:
> > The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
> > 049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
> > removed the only dependency that used it. Setting it had no effect
> > anymore.
> > 
> > So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
> > some reason that commit did not remove all select statements for that
> > symbol. These statements are useless. Remove them too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Done on top of next-20140912. Tested with git grep only!
> 
> Hi Paul,
> 
> could you break the shmobile portion out into a separate patch
> for me to take through my renesas tree?
> 
> I am concerned that taking those changes via a different
> route will result in conflicts as arch/arm/mach-shmobile/Kconfig
> is often updated.

Of course the above comment is redundant if Rafael
has already taken this patch.

> 
> >  arch/arm/mach-omap2/Kconfig    | 5 -----
> >  arch/arm/mach-shmobile/Kconfig | 1 -
> >  drivers/devfreq/Kconfig        | 1 -
> >  3 files changed, 7 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> > index 5b103099626d..f138bd33a463 100644
> > --- a/arch/arm/mach-omap2/Kconfig
> > +++ b/arch/arm/mach-omap2/Kconfig
> > @@ -22,7 +22,6 @@ config ARCH_OMAP4
> >  	bool "TI OMAP4"
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_OMAP2PLUS
> > -	select ARCH_HAS_OPP
> >  	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
> >  	select ARM_CPU_SUSPEND if PM
> >  	select ARM_ERRATA_720789
> > @@ -41,7 +40,6 @@ config SOC_OMAP5
> >  	bool "TI OMAP5"
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_OMAP2PLUS
> > -	select ARCH_HAS_OPP
> >  	select ARM_CPU_SUSPEND if PM
> >  	select ARM_GIC
> >  	select HAVE_ARM_SCU if SMP
> > @@ -53,14 +51,12 @@ config SOC_AM33XX
> >  	bool "TI AM33XX"
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_OMAP2PLUS
> > -	select ARCH_HAS_OPP
> >  	select ARM_CPU_SUSPEND if PM
> >  
> >  config SOC_AM43XX
> >  	bool "TI AM43x"
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_OMAP2PLUS
> > -	select ARCH_HAS_OPP
> >  	select ARM_GIC
> >  	select MACH_OMAP_GENERIC
> >  	select MIGHT_HAVE_CACHE_L2X0
> > @@ -69,7 +65,6 @@ config SOC_DRA7XX
> >  	bool "TI DRA7XX"
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_OMAP2PLUS
> > -	select ARCH_HAS_OPP
> >  	select ARM_CPU_SUSPEND if PM
> >  	select ARM_GIC
> >  	select HAVE_ARM_ARCH_TIMER
> > diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> > index 21f457b56c01..f59019dd986e 100644
> > --- a/arch/arm/mach-shmobile/Kconfig
> > +++ b/arch/arm/mach-shmobile/Kconfig
> > @@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
> >  	select NO_IOPORT_MAP
> >  	select PINCTRL
> >  	select ARCH_REQUIRE_GPIOLIB
> > -	select ARCH_HAS_OPP
> >  
> >  if ARCH_SHMOBILE_MULTI
> >  
> > diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> > index 3dced0a9eae3..2227e9bf3884 100644
> > --- a/drivers/devfreq/Kconfig
> > +++ b/drivers/devfreq/Kconfig
> > @@ -80,7 +80,6 @@ config ARM_EXYNOS4_BUS_DEVFREQ
> >  config ARM_EXYNOS5_BUS_DEVFREQ
> >  	bool "ARM Exynos5250 Bus DEVFREQ Driver"
> >  	depends on SOC_EXYNOS5250
> > -	select ARCH_HAS_OPP
> >  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
> >  	select PM_OPP
> >  	help
> > -- 
> > 1.9.3
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

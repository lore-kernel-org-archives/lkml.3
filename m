Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaHUSFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:05:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56867 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaHUSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:05:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/XnM+eOqihLVi8xmtRL5IM
Date: Thu, 21 Aug 2014 11:04:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v7 1/8] clk: Add temporary mapping to the existing API
Message-ID: <20140821180448.GD10066@atomide.com>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-2-git-send-email-tomeu.vizoso@collabora.com>
 <20140820145006.5251.30923@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820145006.5251.30923@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Turquette <mturquette@linaro.org> [140820 07:53]:
> Quoting Tomeu Vizoso (2014-08-18 08:30:27)
> > To preserve git-bisectability, add aliases from the future provider API to the
> > existing public API.
> > 
> > Also includes clk-provider.h and clk-dev.h in a few places so the right
> > functions are defined.
> > 
> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> 
> Cc'ing Tony for the OMAP2+ parts, Simon & Magnus for the SHMobile parts,
> Jason & Andrew for the Orion parts, Mauro & Kukjin for the Exynos parts.
> 
> This change is super trivial but it's best not to touch these files
> without a heads-up for the owners.

As long as it compiles omap2plus_defconfig it seems safe to me:

Acked-by: Tony Lindgren <tony@atomide.com>

> > ---
> > v7: * Add mappings for clk_notifier_[un]register
> >     * Add more clk-provider.h includes to clk implementations
> > 
> > v4: * Add more clk-provider.h includes to clk implementations
> >     * Add mapping for clk_provider_round_rate
> > ---
> >  arch/arm/mach-omap2/display.c                 |  1 +
> >  arch/arm/mach-omap2/omap_device.c             |  1 +
> >  arch/arm/mach-shmobile/clock.c                |  1 +
> >  arch/arm/plat-orion/common.c                  |  1 +
> >  drivers/clk/berlin/bg2.c                      |  1 +
> >  drivers/clk/berlin/bg2q.c                     |  1 +
> >  drivers/clk/clk-conf.c                        |  1 +
> >  drivers/clk/clkdev.c                          |  1 +
> >  drivers/media/platform/exynos4-is/media-dev.c |  1 +
> >  include/linux/clk-provider.h                  | 25 +++++++++++++++++++++++++
> >  include/linux/clk/zynq.h                      |  1 +
> >  11 files changed, 35 insertions(+)
> > 
> > diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
> > index bf852d7..0f9e479 100644
> > --- a/arch/arm/mach-omap2/display.c
> > +++ b/arch/arm/mach-omap2/display.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> >  #include <linux/err.h>
> >  #include <linux/delay.h>
> >  #include <linux/of.h>
> > diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> > index 01ef59d..fbe8cf0 100644
> > --- a/arch/arm/mach-omap2/omap_device.c
> > +++ b/arch/arm/mach-omap2/omap_device.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/io.h>
> >  #include <linux/clk.h>
> >  #include <linux/clkdev.h>
> > +#include <linux/clk-provider.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/of.h>
> >  #include <linux/notifier.h>
> > diff --git a/arch/arm/mach-shmobile/clock.c b/arch/arm/mach-shmobile/clock.c
> > index 806f940..ed415dc 100644
> > --- a/arch/arm/mach-shmobile/clock.c
> > +++ b/arch/arm/mach-shmobile/clock.c
> > @@ -24,6 +24,7 @@
> >  
> >  #ifdef CONFIG_COMMON_CLK
> >  #include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> >  #include <linux/clkdev.h>
> >  #include "clock.h"
> >  
> > diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
> > index 3ec6e8e..961b593 100644
> > --- a/arch/arm/plat-orion/common.c
> > +++ b/arch/arm/plat-orion/common.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/serial_8250.h>
> >  #include <linux/ata_platform.h>
> >  #include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> >  #include <linux/clkdev.h>
> >  #include <linux/mv643xx_eth.h>
> >  #include <linux/mv643xx_i2c.h>
> > diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
> > index 515fb13..4c81e09 100644
> > --- a/drivers/clk/berlin/bg2.c
> > +++ b/drivers/clk/berlin/bg2.c
> > @@ -19,6 +19,7 @@
> >  
> >  #include <linux/clk.h>
> >  #include <linux/clk-provider.h>
> > +#include <linux/clkdev.h>
> >  #include <linux/kernel.h>
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> > diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
> > index 21784e4..748da9b 100644
> > --- a/drivers/clk/berlin/bg2q.c
> > +++ b/drivers/clk/berlin/bg2q.c
> > @@ -19,6 +19,7 @@
> >  
> >  #include <linux/clk.h>
> >  #include <linux/clk-provider.h>
> > +#include <linux/clkdev.h>
> >  #include <linux/kernel.h>
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> > diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> > index aad4796..d36a7b3 100644
> > --- a/drivers/clk/clk-conf.c
> > +++ b/drivers/clk/clk-conf.c
> > @@ -8,6 +8,7 @@
> >   */
> >  
> >  #include <linux/clk.h>
> > +#include <linux/clkdev.h>
> >  #include <linux/clk-provider.h>
> >  #include <linux/clk/clk-conf.h>
> >  #include <linux/device.h>
> > diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> > index da4bda8..c751d0c 100644
> > --- a/drivers/clk/clkdev.c
> > +++ b/drivers/clk/clkdev.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/string.h>
> >  #include <linux/mutex.h>
> >  #include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> >  #include <linux/clkdev.h>
> >  #include <linux/of.h>
> >  
> > diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> > index 344718d..2620c48 100644
> > --- a/drivers/media/platform/exynos4-is/media-dev.c
> > +++ b/drivers/media/platform/exynos4-is/media-dev.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/bug.h>
> >  #include <linux/clk.h>
> >  #include <linux/clk-provider.h>
> > +#include <linux/clkdev.h>
> >  #include <linux/device.h>
> >  #include <linux/errno.h>
> >  #include <linux/i2c.h>
> > diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> > index 411dd7e..a1a7bb7 100644
> > --- a/include/linux/clk-provider.h
> > +++ b/include/linux/clk-provider.h
> > @@ -16,6 +16,31 @@
> >  
> >  #ifdef CONFIG_COMMON_CLK
> >  
> > +/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
> > +#define clk_core                       clk
> > +
> > +#define __clk_create_clk
> > +
> > +#define clk_provider_get                       clk_get
> > +#define clk_provider_get_sys                   clk_get_sys
> > +#define devm_clk_provider_get                  devm_clk_get
> > +#define of_clk_provider_get                    of_clk_get
> > +#define of_clk_provider_get_by_name            of_clk_get_by_name
> > +
> > +#define clk_provider_set_rate                  clk_set_rate
> > +#define clk_provider_get_rate                  clk_get_rate
> > +#define clk_provider_round_rate                        clk_round_rate
> > +#define clk_provider_set_parent                        clk_set_parent
> > +#define clk_provider_get_parent                        clk_get_parent
> > +#define clk_provider_prepare                   clk_prepare
> > +#define clk_provider_unprepare                 clk_unprepare
> > +#define clk_provider_enable                    clk_enable
> > +#define clk_provider_disable                   clk_disable
> > +#define clk_provider_prepare_enable            clk_prepare_enable
> > +#define clk_provider_disable_unprepare         clk_unprepare
> > +#define clk_provider_notifier_register         clk_notifier_register
> > +#define clk_provider_notifier_unregister       clk_notifier_unregister
> > +
> >  /*
> >   * flags used across common struct clk.  these flags should only affect the
> >   * top-level framework.  custom flags for dealing with hardware specifics
> > diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
> > index 7a5633b..a990a59 100644
> > --- a/include/linux/clk/zynq.h
> > +++ b/include/linux/clk/zynq.h
> > @@ -21,6 +21,7 @@
> >  #define __LINUX_CLK_ZYNQ_H_
> >  
> >  #include <linux/spinlock.h>
> > +#include <linux/clk-provider.h>
> >  
> >  void zynq_clock_init(void);
> >  
> > -- 
> > 1.9.3
> > 

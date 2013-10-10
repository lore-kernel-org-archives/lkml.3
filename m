Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3JJNci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:32:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39497 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab3JJNcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:32:36 -0400
Date: Thu, 10 Oct 2013 08:32:10 -0500
From: Nishanth Menon <nm@ti.com>
To: Joel Fernandes <joelf@ti.com>
CC: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH V6 02/15] ARM: OMAP2+: AM33XX: add lateinit hook for
 calling pm late init
Message-ID: <20131010133209.GA13105@kahuna>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
 <1381361098-8283-1-git-send-email-nm@ti.com>
 <52563BD8.1060703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52563BD8.1060703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:32-20131010, Joel Fernandes wrote:
> On 10/09/2013 06:24 PM, Nishanth Menon wrote:
> > Call OMAP2+ generic lateinit hook from AM specific late init hook.
> > This allows the generic late initializations such as cpufreq hooks
> > to be active.
> > 
> > Cc: Benoit Cousson <bcousson@baylibre.com>
> > Cc: Kevin Hilman <khilman@deeprootsystems.com>
> > Cc: Paul Walmsley <paul@pwsan.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-generic.c |    1 +
> >  arch/arm/mach-omap2/common.h        |    1 +
> >  arch/arm/mach-omap2/io.c            |    6 ++++++
> >  3 files changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> > index 87162e1..b474498 100644
> > --- a/arch/arm/mach-omap2/board-generic.c
> > +++ b/arch/arm/mach-omap2/board-generic.c
> > @@ -180,6 +180,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
> >  	.init_irq	= omap_intc_of_init,
> >  	.handle_irq	= omap3_intc_handle_irq,
> >  	.init_machine	= omap_generic_init,
> > +	.init_late	= am33xx_init_late,
> 
> Instead of adding a new a *_init_late function for every platform, perhaps
> better to just do:
> .init_late	= omap2_common_pm_late_init;
> 
> since that's the only function you're calling.
> 
> Later if more functions are added, then it can be wrapped around.

And what benefit would that give us? we break consistency of functions
available in io.c, considering the work we have already done in
out-of-tree patches on ti-forks, we *do know* that there is more
incoming and has to be done anyways, I prefer having symmetric
functions and a placeholder that folks can add on to.

-- 
Regards,
Nishanth Menon

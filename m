Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaF0MIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:08:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55190 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaF0MIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:08:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+H7ur9wT7LVSU7Q4q7Ncu0DAvRps7jitc=
X-DKIM: OpenDKIM Filter v2.0.1 titan F0A3D59BA6C
Date: Fri, 27 Jun 2014 08:08:16 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: smp_scu: Used defined value instead of
 literal constant
Message-ID: <20140627120816.GD23978@titan.lakedaemon.net>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
 <1403822608-31158-2-git-send-email-gregory.clement@free-electrons.com>
 <53ACA4F3.2070206@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ACA4F3.2070206@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory,

Since you'll be resending this:

On Fri, Jun 27, 2014 at 12:55:47AM +0200, Gregory CLEMENT wrote:
> On 27/06/2014 00:43, Gregory CLEMENT wrote:
> > The first bit of the SCU control register is actually the enable
> > it. So let's name it instead of using literal constant.

nit: s/^it/bit/

thx,

Jason.

> > 
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > ---
> >  arch/arm/kernel/smp_scu.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
> > index 1aafa0d785eb..cfea41b41ad0 100644
> > --- a/arch/arm/kernel/smp_scu.c
> > +++ b/arch/arm/kernel/smp_scu.c
> > @@ -17,6 +17,7 @@
> >  #include <asm/cputype.h>
> >  
> >  #define SCU_CTRL		0x00
> > +#define SCU_CTRL_ENABLE		    BIT(1)
> 
> As Ezequiel rightly pointed it to me, this line is obviously wrong!
> it should be
> +#define SCU_CTRL_ENABLE		    BIT(0)
> 
> >  #define SCU_CONFIG		0x04
> >  #define SCU_CPU_STATUS		0x08
> >  #define SCU_INVALIDATE		0x0c
> > @@ -43,17 +44,18 @@ void scu_enable(void __iomem *scu_base)
> >  	/* Cortex-A9 only */
> >  	if ((read_cpuid_id() & 0xff0ffff0) == 0x410fc090) {
> >  		scu_ctrl = readl_relaxed(scu_base + 0x30);
> > -		if (!(scu_ctrl & 1))
> > -			writel_relaxed(scu_ctrl | 0x1, scu_base + 0x30);
> > +		if (!(scu_ctrl & SCU_CTRL_ENABLE))
> > +			writel_relaxed(scu_ctrl | SCU_CTRL_ENABLE,
> > +				scu_base + 0x30);
> >  	}
> >  #endif
> >  
> >  	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
> >  	/* already enabled? */
> > -	if (scu_ctrl & 1)
> > +	if (scu_ctrl & SCU_CTRL_ENABLE)
> >  		return;
> >  
> > -	scu_ctrl |= 1;
> > +	scu_ctrl |= SCU_CTRL_ENABLE;
> >  	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
> >  
> >  	/*
> > 
> 
> 
> -- 
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com

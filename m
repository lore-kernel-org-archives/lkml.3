Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaHNGxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:53:16 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47026 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaHNGxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:53:14 -0400
Date: Wed, 13 Aug 2014 23:53:10 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Marc Carino <marc.ceeeee@gmail.com>, kernel-janitors@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 11/14] ARM: brcmstb: delete unneeded test before
 of_node_put
Message-ID: <20140814065310.GK11952@brian-ubuntu>
References: <1407492475-26283-11-git-send-email-Julia.Lawall@lip6.fr>
 <20140813222212.GB18411@ld-irv-0074>
 <alpine.DEB.2.02.1408140733190.2053@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408140733190.2053@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 07:37:28AM +0200, Julia Lawall wrote:
> On Wed, 13 Aug 2014, Brian Norris wrote:
> > On Fri, Aug 08, 2014 at 12:07:52PM +0200, Julia Lawall wrote:
> > > diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
> > > index af780e9..c515ea1 100644
> > > --- a/arch/arm/mach-bcm/platsmp-brcmstb.c
> > > +++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
> > > @@ -227,7 +227,7 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
> > >  	if (!syscon_np) {
> > >  		pr_err("can't find phandle %s\n", name);
> > >  		rc = -EINVAL;
> > > -		goto cleanup;
> > > +		goto out;
> > >  	}
> > >  
> > >  	cpubiuctrl_block = of_iomap(syscon_np, 0);
> > > @@ -256,9 +256,8 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
> > >  	}
> > >  
> > >  cleanup:
> > > -	if (syscon_np)
> > > -		of_node_put(syscon_np);
> > > -
> > > +	of_node_put(syscon_np);
> > > +out:
> > 
> > Is there a good reason for this new label? I thought part of the point
> > of this semantic patch is that the previous line (of_node_put()) is a
> > no-op for NULL arguments.
> 
> Personally, I prefer code to only be executed if it needs to be.  It is 
> helpful from a program analysis point of view, and I think it helps 
> someone trying to understand the code.
> 
> That is, when I am trying to understand some unknown code, I may look at 
> the cleanup code and try to figure out why each piece of it is executed.  
> If some of it is statically known to be irrelevant, it is confusing.
> 
> But I you think the other way around, and would rather have just one label 
> that contains anything that might ever be useful, then I guess that is a 
> reasonable point of view as well.

Yeah, I personally just look to avoid unnecessary labels.

Thanks for explaining your thought process.

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3FMO6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:58:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45162 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab3FMO6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:58:34 -0400
Date: Thu, 13 Jun 2013 09:58:03 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
Message-ID: <20130613145803.GA32324@kahuna>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
 <20130610164905.GJ1403@sirena.org.uk>
 <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
 <20130610180150.GQ1403@sirena.org.uk>
 <20130613133950.GA32174@kahuna>
 <20130613144726.GY1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130613144726.GY1403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:47-20130613, Mark Brown wrote:
> On Thu, Jun 13, 2013 at 08:39:50AM -0500, Nishanth Menon wrote:
> 
> > I am having a bit of a difficulty trying to understand your concern
> > here.
> 
> Your device tree for this stuff appears to mostly consist of repeating
> the description of the PMIC that we already have - this really doesn't
> seem like a great result.
> 
> > Problem statement:
> 
> > OMAP has this weird custom h/w where one programs the voltage and that
> > voltage is send over i2c - this is not same as Tegra's lookup table
> > array which automatically sends out entries, in OMAP, software has to trigger
> > the voltage transition
> 
> The basic idea that's important here is that you need to figure out how
> to tell the hardware what to write - how those writes get triggered is a
> separate problem.
> 
> > If your concern was describing PMIC parameters in dts, I can easily move
> > them inside the omap_pmic driver and provide required compatible flags.
> > If, on the other hand, the entire approach followed is flawed, I'd like to
> > understand the rationale for the same.
> 
> That's the biggest problem I saw so far but to be honest I've not
> drilled down too much into the specifics.  From my point of view the
> main thing is how this fits into the frameworks and so on, having the
> register information in the DT was an alarm flag that suggested the
> overall approach was a concern.
OK. would you be ok with an generic omap_pmic driver if the PMIC
specific data set is moved into OF compatible data?
I am proposing moving the following into OF match data.
ti,i2c-slave-address
ti,i2c-voltage-register
ti,i2c-command-register
ti,slew-rate-microvolt
ti,step-size-micro-volts
ti,voltage-selector-set-bits
ti,voltage-selector-mask
ti,voltage-selector-offset
ti,non-zero-voltage-selector

The only thing I propose to retain is board specific variations - e.g.
gpios, boot voltage and standard regulator min,max overrides if any.

I can also do voltage selector based operations while at it.

-- 
Regards,
Nishanth Menon

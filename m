Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaDPJZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:25:50 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38715 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaDPJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:25:46 -0400
Date: Wed, 16 Apr 2014 10:25:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mfd: arizona: Factor out read of device tree GPIOs
Message-ID: <20140416092540.GE4754@lee--X1>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1396340845-24060-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140415102527.GD27091@lee--X1>
 <20140415130140.GA27294@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140415130140.GA27294@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This patch factors out the reading of GPIOs for the Arizona devices
> > > into a helper function.
> > > 
> > > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > > ---
> > >  drivers/mfd/arizona-core.c       |   33 ++++++++++++++++++++++++---------
> > >  include/linux/mfd/arizona/core.h |    3 +++
> > >  2 files changed, 27 insertions(+), 9 deletions(-)

[...]

> > > +EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
> > > +
> > 
> > Are you sure you're going to use this externally?
> > 
> > NB: I haven't looked at the remainder of the set yet.
> 
> Yeah we move the ldoena gpio into the LDO driver, and later we
> will be adding a polarity GPIO into the extcon driver.

Okay, just checking.

> > >  static int arizona_of_get_core_pdata(struct arizona *arizona)
> > >  {
> > > +	struct arizona_pdata *pdata = &arizona->pdata;
> > >  	int ret, i;
> > >  
> > > -	arizona->pdata.reset = of_get_named_gpio(arizona->dev->of_node,
> > > -						 "wlf,reset", 0);
> > > -	if (arizona->pdata.reset < 0)
> > > -		arizona->pdata.reset = 0;
> > > -
> > > -	arizona->pdata.ldoena = of_get_named_gpio(arizona->dev->of_node,
> > > -						  "wlf,ldoena", 0);
> > > -	if (arizona->pdata.ldoena < 0)
> > > -		arizona->pdata.ldoena = 0;
> > > +	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
> > > +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
> > 
> > I guess this pdata is populated by DT?
> 
> Yeah that is correct, the Arizona driver populates the pdata from
> the DT then the rest of the driver just uses the pdata in both DT
> and pdata cases.

Sounds ugly when you put it like that, but I know that a _lot_ of
other drivers do the same thing.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

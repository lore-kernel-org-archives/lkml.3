Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaDONK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:10:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54174 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaDONKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:10:55 -0400
Date: Tue, 15 Apr 2014 14:10:54 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing
	from arizona-core
Message-ID: <20140415131054.GB27294@opensource.wolfsonmicro.com>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1396340845-24060-3-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140415101200.GC27091@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415101200.GC27091@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:12:00AM +0100, Lee Jones wrote:
> On Tue, 01 Apr 2014, Charles Keepax wrote:
> 
> > It is more idiomatic to process things relating to the regulator in its
> > driver. This patch moves both processing of device tree relating to the
> > regulator and checking if the regulator is external from arizona-core
> > into the regulator driver.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c       |   12 +++---------
> >  drivers/regulator/arizona-ldo1.c |   32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 35 insertions(+), 9 deletions(-)
> 
> [...]
> 
> > diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
> > index b1033d3..211af83 100644
> > --- a/drivers/regulator/arizona-ldo1.c
> > +++ b/drivers/regulator/arizona-ldo1.c
> > @@ -178,6 +178,22 @@ static const struct regulator_init_data arizona_ldo1_default = {
> >  	.num_consumer_supplies = 1,
> >  };
> >  
> > +#ifdef CONFIG_OF
> > +static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
> > +{
> > +	struct arizona_pdata *pdata = &arizona->pdata;
> > +
> > +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
> > +
> > +	return 0;
> > +}
> > +#else
> > +static inline int arizona_ldo1_of_get_pdata(struct arizona *arizona)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> 
> I think "if (IS_ENABLED(CONFIG_OF))" is preferred now, but I guess
> that's up to Mark.

I am happy to respin if this is preferred.

Thanks,
Charles

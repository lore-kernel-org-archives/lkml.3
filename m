Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaCROLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:11:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52689 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994AbaCROLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:11:44 -0400
Date: Tue, 18 Mar 2014 14:11:42 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] regulator: arizona-ldo1: Move setup processing
	from arizona-core
Message-ID: <20140318141142.GC1665@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1395139757-6907-4-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140318111049.GJ11706@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318111049.GJ11706@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:10:49AM +0000, Mark Brown wrote:
> On Tue, Mar 18, 2014 at 10:49:12AM +0000, Charles Keepax wrote:
> 
> > +#ifdef CONFIG_OF
> > +static int arizona_ldo1_get_pdata(struct arizona *arizona,
> > +				  struct regulator_config *config)
> > +{
> > +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true,
> > +				  &config->ena_gpio);
> > +
> > +	return 0;
> > +}
> > +#else
> > +static inline int arizona_ldo1_get_pdata(struct arizona *arizona,
> > +					 struct regulator_config *config)
> > +{
> > +	struct arizona_pdata *pdata = &arizona->pdata;
> > +
> > +	config->ena_gpio = arizona->pdata.ldoena;
> 
> This breaks non-DT systems booting a kernel which has DT support
> compiled in.  It's also more than simple code motion which is what the
> changelog claimed this was doing.

Oops.. sorry that is a good point I will respin these.

Thanks,
Charles

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbaGPI1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:27:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13243 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbaGPI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:27:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jul 2014 01:16:24 -0700
Date: Wed, 16 Jul 2014 11:27:40 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] clk: tegra: make tegra_clocks_apply_init_table
 arch_initcall
Message-ID: <20140716082740.GK23218@tbergstrom-lnx.Nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
 <20140716071932.GB7978@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140716071932.GB7978@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:19:33AM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jul 15, 2014 at 06:24:32PM +0300, Peter De Schrijver wrote:
> [...]
> > diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> > index d081732..65cde4e 100644
> > --- a/drivers/clk/tegra/clk.c
> > +++ b/drivers/clk/tegra/clk.c
> > @@ -290,10 +290,13 @@ struct clk ** __init tegra_lookup_dt_id(int clk_id,
> >  
> >  tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
> >  
> > -void __init tegra_clocks_apply_init_table(void)
> > +static int __init tegra_clocks_apply_init_table(void)
> >  {
> >  	if (!tegra_clk_apply_init_table)
> > -		return;
> > +		return 0;
> 
> Shouldn't this be an error? Or perhaps WARN()? To make sure this gets

An arch_initcall will be called for every ARM platform I think? In case
this gets called on a non-Tegra platform, tegra_clk_apply_init_table will not
be set and therefore a silent return 0; seems the most appropriate thing to do
to me?

Cheers,

Peter.

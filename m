Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3JPHfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:35:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14219 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3JPHfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:35:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 00:35:18 -0700
Date: Wed, 16 Oct 2013 10:35:14 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 10/19] clk: tegra: move audio clk to common file
Message-ID: <20131016073514.GB5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <1381848794-11761-11-git-send-email-pdeschrijver@nvidia.com>
 <525D93E8.1010903@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525D93E8.1010903@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:13:44PM +0200, Stephen Warren wrote:
> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> > Move audio clocks and PLLA initialization to a common file so it can be used by
> > multiple Tegra SoCs.
> 
> > diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> 
> > +static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
> > +	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
> > +	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
> > +	[tegra_clk_uarta] = { .dt_id = TEGRA114_CLK_UARTA, .present = true },
> ...
> > @@ -2194,7 +2167,7 @@ static void __init tegra114_clock_init(struct device_node *np)
> ...
> > +	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, &pll_a_params);
> 
> I think it's worth explaining in the commit description why an array of
> not-remotely-audio-related clocks is being passed into an
> audio-clock-initialization function.
> 

This is mostly to avoid a build warning. I could put this in a separate file,
but then, there won't be any user before this is merged.

Cheers,

Peter.

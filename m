Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3JRM1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:27:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10587 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3JRM1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:27:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 05:27:49 -0700
Date: Fri, 18 Oct 2013 15:27:46 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 06/15] clk: tegra: move fields to
 tegra_clk_pll_params
Message-ID: <20131018122746.GB25591@tbergstrom-lnx.Nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
 <1382013526-12800-7-git-send-email-pdeschrijver@nvidia.com>
 <CAL1qeaH+DVdjB-jJMhqKWbFG7TtTAgOuSk3esRh_HPT4YfwPdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL1qeaH+DVdjB-jJMhqKWbFG7TtTAgOuSk3esRh_HPT4YfwPdA@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:59:30AM +0200, Andrew Bresticker wrote:
> Hi Peter,
> 
> > @@ -1682,17 +1664,15 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
> >  struct clk *tegra_clk_register_plle_tegra114(const char *name,
> >                                 const char *parent_name,
> >                                 void __iomem *clk_base, unsigned long flags,
> > -                               unsigned long fixed_rate,
> >                                 struct tegra_clk_pll_params *pll_params,
> > -                               struct tegra_clk_pll_freq_table *freq_table,
> >                                 spinlock_t *lock)
> >  {
> >         struct tegra_clk_pll *pll;
> >         struct clk *clk;
> >         u32 val, val_aux;
> >
> > -       pll = _tegra_init_pll(clk_base, NULL, fixed_rate, pll_params,
> > -                             TEGRA_PLL_HAS_LOCK_ENABLE, freq_table, lock);
> > +       pll_params->flags = TEGRA_PLL_HAS_LOCK_ENABLE;
> 
> Why are we just overwriting the flags?  We pass in flags here:
> 
> > @@ -661,6 +685,9 @@ static struct tegra_clk_pll_params pll_e_params = {
> >         .lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
> >         .lock_delay = 300,
> >         .div_nmp = &plle_nmp,
> > +       .freq_table = pll_e_freq_table,
> > +       .flags = TEGRA_PLL_FIXED,
> 
> TEGRA_PLL_FIXED doesn't actually make a difference in the
> plle_tegra114 case, but it would be nice to be correct about setting
> it.

Yeah indeed.

Cheers,

Peter.

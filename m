Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3BFMcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:32:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6361 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFMcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:32:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Feb 2013 04:30:09 -0800
Date: Wed, 6 Feb 2013 14:32:22 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 01/10] clk: tegra: Refactor PLL programming code
Message-ID: <20130206123222.GI3073@tbergstrom-lnx.Nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
 <1359713962-16822-2-git-send-email-pdeschrijver@nvidia.com>
 <510F4FF7.3050502@nvidia.com>
 <20130204143233.GV2364@tbergstrom-lnx.Nvidia.com>
 <51109BB3.8000706@nvidia.com>
 <20130205132355.GD3073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130205132355.GD3073@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 02:23:55PM +0100, Peter De Schrijver wrote:
> On Tue, Feb 05, 2013 at 06:42:11AM +0100, Prashant Gaikwad wrote:
> > On Monday 04 February 2013 08:02 PM, Peter De Schrijver wrote:
> > > On Mon, Feb 04, 2013 at 07:06:47AM +0100, Prashant Gaikwad wrote:
> > >> On Friday 01 February 2013 03:48 PM, Peter De Schrijver wrote:
> > > ...
> > >
> > >>> -static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll,
> > >>> -                                void __iomem *lock_addr, u32 lock_bit_idx)
> > >>> +static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
> > >>>    {
> > >>>           int i;
> > >>> -       u32 val;
> > >>> +       u32 val, lock_bit;
> > >>> +       void __iomem *lock_addr;
> > >>>
> > >>>           if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
> > >>>                   udelay(pll->params->lock_delay);
> > >>>                   return 0;
> > >>>           }
> > >>>
> > >>> +       lock_addr = pll->clk_base + pll->params->base_reg;
> > >> This will not work for PLLE. Lock bit for PLLE is in misc register.
> > >>
> > >>> +       lock_bit = BIT(pll->params->lock_bit_idx);
> > >>> +
> > >>>           for (i = 0; i < pll->params->lock_delay; i++) {
> > >>>                   val = readl_relaxed(lock_addr);
> > >>> -               if (val & BIT(lock_bit_idx)) {
> > >>> +               if (val & lock_bit) {
> > >> Need to change the lock bit idx parameter for Tegra20 and Tegra30 PLLs
> > >> else this patch will break those.
> > >>
> > > Looking at commit 37c26a906527b8a6a252614ca83d21ad318c4e84 and commit
> > > b08e8c0ecc42afa3a2e1019851af741980dd5a6b, these fields seem correctly
> > > initialized for both Tegra20 and Tegra30? Or am I missing something?
> > 
> > Ohh, I missed to read
> > 
> > lock_bit = BIT(pll->params->lock_bit_idx);
> > 
> > 
> > Am I missing something about PLLE lock_addr also?
> > 
> 
> Ah no indeed... my bad. So we need a lock_addr field.
> 

Or a flag. Flag seems less invasive for now.

Cheers,

Peter.

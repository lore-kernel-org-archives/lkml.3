Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3BDOIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:08:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15382 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3BDOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:08:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 06:07:33 -0800
Date: Mon, 4 Feb 2013 16:07:55 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 09/10] clk: tegra: Implement clocks for Tegra114
Message-ID: <20130204140755.GU2364@tbergstrom-lnx.Nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
 <1359713962-16822-10-git-send-email-pdeschrijver@nvidia.com>
 <510F5E87.90801@nvidia.com>
 <20130204104531.GQ2364@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130204104531.GQ2364@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 11:45:31AM +0100, Peter De Schrijver wrote:
> On Mon, Feb 04, 2013 at 08:08:55AM +0100, Prashant Gaikwad wrote:

...

> > > +
> > > +       /* dsia */
> > > +       clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
> > > +                              ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
> > > +                              clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
> > > +       clks[dsia_mux] = clk;
> > > +       clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
> > > +                                   0, 48, &periph_h_regs,
> > > +                                   periph_clk_enb_refcnt);
> > > +       clk_register_clkdev(clk, "dsia", "tegradc.0");
> > > +       clks[dsia] = clk;
> > > +
> > > +       /* dsib */
> > > +       clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
> > > +                              ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
> > > +                              clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
> > > +       clks[dsib_mux] = clk;
> > > +       clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
> > > +                                   0, 82, &periph_u_regs,
> > > +                                   periph_clk_enb_refcnt);
> > > +       clk_register_clkdev(clk, "dsib", "tegradc.1");
> > > +       clks[dsib] = clk;
> > > +
> > 
> > Can we use periph no div clock here for dsia and dsib?
> > 
> 
> Will check.
> 

Not as such. As you can see the muxes need a lock to protect access to the
PLLD_BASE and PLLD2_BASE registers respectively. The periph no div clock
doesn't provide for these locks though. Do you think it makes sense to add
the lock support for these 2 clocks?

Cheers,

Peter.

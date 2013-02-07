Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3BGQSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:18:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3417 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:18:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Feb 2013 08:17:44 -0800
Date: Thu, 7 Feb 2013 18:18:09 +0200
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
Message-ID: <20130207161809.GQ3073@tbergstrom-lnx.Nvidia.com>
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

> 
> > > +       /* xusb_hs_src */
> > > +       val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
> > > +       val |= BIT(25); /* always select PLLU_60M */
> > > +       writel(val, clk_base + CLK_SOURCE_XUSB_SS_SRC);
> > > +
> > > +       clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
> > > +                                       1, 1);
> > > +       clks[xusb_hs_src] = clk;
> > > +
> > 
> > With device tree we can directly use pll_u_60M, no need to register 
> > clock with fixed factor 1.
> 
> This is true for now. In the future these clocks will need to be dvfs aware
> though. I think it makes sense to have a separate clock then?
> 

As this seems to be a different clock (ie. the hw allows you to select a
different parent), I think keeping this node makes sense.

Cheers,

Peter.

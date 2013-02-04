Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3BDOeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:34:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19159 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3BDOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:34:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 06:33:39 -0800
Date: Mon, 4 Feb 2013 16:34:01 +0200
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
Message-ID: <20130204143401.GW2364@tbergstrom-lnx.Nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
 <1359713962-16822-10-git-send-email-pdeschrijver@nvidia.com>
 <510F5E87.90801@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <510F5E87.90801@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:08:55AM +0100, Prashant Gaikwad wrote:
> On Friday 01 February 2013 03:48 PM, Peter De Schrijver wrote:

...

> > +       /* xusb_hs_src */
> > +       val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
> > +       val |= BIT(25); /* always select PLLU_60M */
> > +       writel(val, clk_base + CLK_SOURCE_XUSB_SS_SRC);
> > +
> > +       clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
> > +                                       1, 1);
> > +       clks[xusb_hs_src] = clk;
> > +
> 
> With device tree we can directly use pll_u_60M, no need to register 
> clock with fixed factor 1.
> Same comment for dis1-fixed, dsi2-fixed and mipi-cal-fast clocks.
> 

Does it make sense to have separate DT IDs at all then?

Cheers,

Peter.

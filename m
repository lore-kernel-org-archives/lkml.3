Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3J3WSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:18:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11496 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3J3WSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:18:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Oct 2013 15:13:36 -0700
Date: Thu, 31 Oct 2013 00:18:33 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
Message-ID: <20131030221833.GQ22111@tbergstrom-lnx.Nvidia.com>
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
 <527128B5.2020101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <527128B5.2020101@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:41:41PM +0100, Stephen Warren wrote:
> On 10/29/2013 06:41 PM, Peter De Schrijver wrote:
> > Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> > Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
> 
> Why? What benefit does this give, or what bug does this fix?
> 

Otherrwise Tegra114 will crash on boot.

> > diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> 
> >  	val_aux = pll_readl(pll_params->aux_reg, pll);
> >  
> >  	if (val & PLL_BASE_ENABLE) {
> > -		if (!(val_aux & PLLE_AUX_PLLRE_SEL))
> > +		if ((val_aux & PLLE_AUX_PLLRE_SEL) || (val_aux & val_aux))
> 
> Isn't "|| (val_aux & val_aux)" always true, at least if the value is
> non-zero? Either this should be simply "|| val_aux", or one of those two
> "val_aux" is the wrong thing.
> 

It should have been val_aux & PLLE_AUX_PLLP_SEL...

Cheers,

Peter.

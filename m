Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3JQH5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:57:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3144 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3JQH5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:57:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Oct 2013 00:57:46 -0700
Date: Thu, 17 Oct 2013 10:57:43 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] clk: tegra: Add support for PLLSS
Message-ID: <20131017075743.GQ5643@tbergstrom-lnx.Nvidia.com>
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
 <1381850098-12357-2-git-send-email-pdeschrijver@nvidia.com>
 <525DA373.6040805@wwwdotorg.org>
 <20131016074829.GD5643@tbergstrom-lnx.Nvidia.com>
 <525ECB08.4020201@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525ECB08.4020201@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 07:21:12PM +0200, Stephen Warren wrote:
> On 10/16/2013 01:48 AM, Peter De Schrijver wrote:
> > On Tue, Oct 15, 2013 at 10:20:03PM +0200, Stephen Warren wrote:
> >> On 10/15/2013 09:14 AM, Peter De Schrijver wrote:
> >>> Tegra124 introduces a new PLL type, PLLSS. Add support for it.
> >>
> >>> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> >>
> >>
> >>> +static int clk_pllss_set_rate(struct clk_hw *hw, unsigned long rate,
> >>> +				unsigned long parent_rate)
> >>
> >> This function seems pretty generic. Is it possible to share a bit more
> >> code with any of the other pllXXX_set_rate() functions?
> >>
> >>> +struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
> >>> +				void __iomem *clk_base, unsigned long flags,
> >>> +				struct tegra_clk_pll_params *pll_params,
> >>> +				spinlock_t *lock)
> >>
> >>> +	val = pll_readl_base(pll);
> >>> +	if (val & PLLSS_REF_SRC_SEL_MASK) {
> >>> +		WARN(1, "Unknown parent selected for %s: %d\n", name,
> >>> +			(val & PLLSS_REF_SRC_SEL_MASK) >>
> >>> +			PLLSS_REF_SRC_SEL_SHIFT);
> >>> +		kfree(pll);
> >>> +		return ERR_PTR(-EINVAL);
> >>> +	}
> >>
> >> If there's a field in HW that muxes the clock input between n clocks,
> >> why does this function assume there's a single parent for this PLL, by
> >> taking a "const char *parent_name" parameter?
> >>
> >> What happens if the bootloader changed this field in HW; is the kernel
> >> simply not able to boot?
> >>
> > 
> > This logic comes from downstream. I guess it means we're running in an
> > unvalidated configuration. Do you think we should expose all parents 
> > anyway? Even if not all configurations have been validated?
> > (which is quite likely)
> 
> If we only support one particular parent, why not force the register
> field to the desired value, rather than failing?

Sounds reasonable indeed. I will do that in the next version.

Cheers,

Peter.

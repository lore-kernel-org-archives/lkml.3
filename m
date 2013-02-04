Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3BDKii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:38:38 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3104 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3BDKig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:38:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Feb 2013 02:37:59 -0800
Date: Mon, 4 Feb 2013 12:37:56 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Rhyland Klein <rklein@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Simon Glass <sjg@chromium.org>, Mike Turquette <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 04/10] clk: tegra: Add new fields and PLL types for
 Tegra114
Message-ID: <20130204103756.GP2364@tbergstrom-lnx.Nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
 <1359713962-16822-5-git-send-email-pdeschrijver@nvidia.com>
 <510C1A2E.5010408@nvidia.com>
 <510F56B1.5060409@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <510F56B1.5060409@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 07:35:29AM +0100, Prashant Gaikwad wrote:
> On Saturday 02 February 2013 01:10 AM, Rhyland Klein wrote:
> > On 2/1/2013 5:18 AM, Peter De Schrijver wrote:
> >> Tegra114 introduces new PLL types. This requires new clocktypes as well
> >> as some new fields in the pll structure.
> >>
> >> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> >> ---
> >>    drivers/clk/tegra/clk-pll.c |  719 +++++++++++++++++++++++++++++++++++++++++++
> >>    drivers/clk/tegra/clk.h     |   47 +++
> >>    2 files changed, 766 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> >> index 87d2f34..50114b7 100644
> >> --- a/drivers/clk/tegra/clk-pll.c
> >> +++ b/drivers/clk/tegra/clk-pll.c
> >> [snip]
> >> +struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
> >> +                         void __iomem *clk_base, void __iomem *pmc,
> >> +                         unsigned long flags, unsigned long fixed_rate,
> >> +                         struct tegra_clk_pll_params *pll_params,
> >> +                         u32 pll_flags,
> >> +                         struct tegra_clk_pll_freq_table *freq_table,
> >> +                         spinlock_t *lock)
> >> +{
> >> +       if (!pll_params->pdiv_tohw)
> >> +               return -EINVAL;
> >> +
> > This will cause the following warning:
> > warning: return makes pointer from integer without a cast
> >
> > Same with occurrences in tegra_clk_register_pllm and
> > tegra_clk_register_pllc.
> >
> > Should this instead be returning NULL?
> 
> return ERR_PTR(-EINVAL)
> 

Indeed. I noticed that only after I sent this patchset. Already fixed in
my own tree.

Cheers,

Peter.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3ANFdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:33:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13458 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3ANFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:33:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 13 Jan 2013 21:32:01 -0800
Date: Mon, 14 Jan 2013 07:33:00 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] clk: tegra: add clock support for tegra30
Message-ID: <20130114073300.ac8d5d4ffffe2d881798a2a2@nvidia.com>
In-Reply-To: <50F086E2.6010806@wwwdotorg.org>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
	<1357890387-23245-8-git-send-email-pgaikwad@nvidia.com>
	<20130111141725.ce3177ad04fc700186dc694d@nvidia.com>
	<50F086E2.6010806@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 22:40:50 +0100
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 01/11/2013 05:17 AM, Hiroshi Doyu wrote:
> > On Fri, 11 Jan 2013 08:46:25 +0100
> > Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> > 
> >> Add tegra30 clock support based on common clock framework.
> >>
> >> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> > .......
> >> +static void __init tegra30_pll_init(void)
> >> +{
> >> +       struct clk *clk;
> >> +
> >> +       /* PLLC */
> >> +       clk = tegra_clk_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
> >> +                           0, &pll_c_params,
> >> +                           TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
> >> +                           pll_c_freq_table, NULL);
> >> +       clk_register_clkdev(clk, "pll_c", NULL);
> >> +       clks[pll_c] = clk;
> > 
> > Just I noticed that there are quite many same itegration of:
> > 
> > 	clk_register_clkdev(clk, <ID name>, ?);
> > 	clks[<ID>] = clk;
> > 
> > ID == <ID name>
> > 
> > Can any macro/func do the above at once?
> 
> To my mind, a macro would obfuscate this fairly simple code, unless
> there is a table somewhere the maps <ID> to <ID name> which would allow
> saving some code space (I just looked; I don't think there is).

Agree that those 2 lines may be too simple. I thought that ##string##
could do the above. One of the benefit to make them at once is that
we'll get a single entry point to register clkdev in tegra. For
example, if you insert some debug print in it, it would shows all
clkdev registration.

> Eventually (later cleanup), I wouldn't be surprised if both parameters
> to clk_register_clkdev() became NULL in most cases, since most lookups
> are through DT by the end of this series.

Ok.

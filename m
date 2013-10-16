Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3JPOex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:34:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11141 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3JPOev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:34:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 07:34:50 -0700
Date: Wed, 16 Oct 2013 17:34:48 +0300
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
Subject: Re: [PATCH v3 08/19] clk: tegra: add common infra for DT clocks
Message-ID: <20131016143448.GK5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <1381848794-11761-9-git-send-email-pdeschrijver@nvidia.com>
 <525D9117.9050009@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525D9117.9050009@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:01:43PM +0200, Stephen Warren wrote:
> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> > Introduce a common infrastructure for sharing clock initialization between
> > SoCs.
> 
> > diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> 
> > +struct clk ** __init tegra_lookup_dt_id(int clk_id,
> > +					struct tegra_clk *tegra_clk)
> > +{
> > +	if (tegra_clk[clk_id].present)
> > +		return &clks[tegra_clk[clk_id].dt_id];
> > +	else
> > +		return NULL;
> 
> Does this need range-checking? Or do we assume that since this is an
> internal function, "clk_id" will never be out-of-range?

That was my assumption indeed. I could add a range check if you think that's
useful.

Cheers,

Peter.

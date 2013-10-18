Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3JRMSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:18:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10317 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3JRMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:18:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 05:14:02 -0700
Date: Fri, 18 Oct 2013 15:18:29 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/15] clk: tegra: common periph_clk_enb_refcnt and
 clks
Message-ID: <20131018121829.GA25591@tbergstrom-lnx.Nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
 <1382013526-12800-4-git-send-email-pdeschrijver@nvidia.com>
 <CAL1qeaFrm50m0a3csY=04MNQENM_DY5fgBrq5bdsm8dHnLj1gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL1qeaFrm50m0a3csY=04MNQENM_DY5fgBrq5bdsm8dHnLj1gA@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:26:20AM +0200, Andrew Bresticker wrote:
> Hi Peter,
> 
> >  static void __init tegra30_clock_init(struct device_node *np)
> >  {
> >         struct device_node *node;
> > -       int i;
> >
> >         clk_base = of_iomap(np, 0);
> >         if (!clk_base) {
> > @@ -1916,8 +1910,11 @@ static void __init tegra30_clock_init(struct device_node *np)
> >                 BUG();
> >         }
> >
> > -       if (tegra_clk_set_periph_banks(5) < 0)
> > +       clks = tegra_clk_init(clk_max, 5);
> > +       if (!clks) {
> > +               WARN_ON(1);
> 
> Really minor nit: it seems strange that we WARN here for t30, but not
> for t114 or t20.

There used to be a warning for all 3, but I removed it and apparently forgot
t30.

Cheers,

Peter.

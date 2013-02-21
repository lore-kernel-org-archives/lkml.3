Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3BUJ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:57:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9697 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3BUJ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:57:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Feb 2013 01:56:15 -0800
Date: Thu, 21 Feb 2013 11:56:54 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130221095654.GH23234@tbergstrom-lnx.Nvidia.com>
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
 <5123C18A.9010604@wwwdotorg.org>
 <5124C18F.6070108@nvidia.com>
 <20130220131112.GE2726@opensource.wolfsonmicro.com>
 <5124CEF5.3060605@nvidia.com>
 <512506F9.2030508@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <512506F9.2030508@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 06:25:13PM +0100, Stephen Warren wrote:
> On 02/20/2013 06:26 AM, Laxman Dewangan wrote:
> > On Wednesday 20 February 2013 06:41 PM, Mark Brown wrote:
> >> * PGP Signed by an unknown key
> >>
> >> On Wed, Feb 20, 2013 at 05:59:03PM +0530, Laxman Dewangan wrote:
> >>>>> +    tspi->clk = devm_clk_get(&pdev->dev, "spi");
> >>>> Does this HW block use multiple clocks? If not, I think s/"spi"/NULL/
> >>>> there, just like the Tegra20 driver.
> >>> No, spi controller uses the only one clock. I will change to NULL.
> >> I'm never convinced that NULL is a helpful clock name to pick, it's not
> >> awesome if you ever acquire a second clock.
> > 
> > I had other idea of okeeping clock name here for power optimization.
> > Spi controller can take the power source ffrom different clock source
> > say clk_m (crystal) and pllp.
> > 
> > I want to set the parent clock dynamically based on required speed so
> > that if the desire speed can be meet from clk_m, no need to increase pll
> > count and possible we may endup with siwtchng off pllp which can save
> > power.
> > 
> > So for this I may require
> > 
> > spi_clk = devm_clk_get(&pdev->dev, "spi");
> > spi_clkm = devm_clk_get(&pdev->dev, "clmkm");
> > spi_pllp = devm_clk_get(&pdev->dev, "pllp");
> > 
> > and call clk_set_parent(spi_clk, spi_clkm) or clk_set_parent(spi_clk,
> > spi_pllp).
> 
> OK, so that's certainly an argument for requesting a specific clock name
> rather than NULL.
> 

The list of possible parents for each clock is determined by the SoC and is
already known to CCF, so maybe we just need to add a function to CCF to allow
the drivers to query the list of possible parents?

Cheers,

Peter.

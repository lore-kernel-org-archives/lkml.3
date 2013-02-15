Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3BOJY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:24:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12531 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3BOJYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:24:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Feb 2013 01:24:10 -0800
Date: Fri, 15 Feb 2013 11:24:07 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
Message-ID: <20130215092407.GO3073@tbergstrom-lnx.Nvidia.com>
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
 <1360868369-20093-2-git-send-email-hdoyu@nvidia.com>
 <511D45E0.1080105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <511D45E0.1080105@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 09:15:28PM +0100, Stephen Warren wrote:
> On 02/14/2013 11:59 AM, Hiroshi Doyu wrote:
> > To replace magic number in tegra_car:
> > 
> > -               clocks = <&tegra_car 28>;
> > +               clocks = <&tegra_car CLK_HOST1X>;
> 
> > diff --git a/arch/arm/boot/dts/tegra20-car.h b/arch/arm/boot/dts/tegra20-car.h
> 
> Sorry, forgot a couple small comments the last time around.
> 
> This file should probably have some header indicating which binding it
> describes, rather like the GPIO header in my patch series.
> 
> > +#define CLK_CPU 0
> 
> I'd suggest naming that TEGRA20_CLK_CPU, so that the various different
> clock headers don't conflict. It's not too likely that more than one of
> the /Tegra/ clock headers will be included at once, but it doesn't seem
> that unlikely that a board file could end up having a Tegra clock header
> included plus various other clock headers for some other chip that has
> some clock outputs.
> 

I would suggest removing this clock. It's not actually implemented in the CCF
and rather useless. If you would gate the CPU clock from the CPU by writing to
this register, how would you ungate it? :) Note that this would gate the clock
to all CPUs.

Cheers,

Peter.


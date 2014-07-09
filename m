Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaGIMoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:44:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8895 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaGIMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:44:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Jul 2014 05:33:13 -0700
Date: Wed, 9 Jul 2014 15:43:44 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140709124344.GK23218@tbergstrom-lnx.Nvidia.com>
References: <20140619080234.GK3407@tbergstrom-lnx.Nvidia.com>
 <53A3096B.1040409@wwwdotorg.org>
 <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
 <20140708130501.GC9516@ulmo>
 <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
 <20140709063130.GA3170@ulmo>
 <20140709083311.GE23218@tbergstrom-lnx.Nvidia.com>
 <20140709102551.GA19357@ulmo>
 <20140709110816.GF23218@tbergstrom-lnx.Nvidia.com>
 <20140709120400.GA3819@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140709120400.GA3819@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:04:02PM +0200, Thierry Reding wrote:
> > For those 2 domains we can find the necessary clocks and resets by parsing
> > the relevant existing DT nodes for PCIe and gr3d. For clocks, this isn't
> > even needed as we can always register some extra clkdev's to get them. There
> > is no equivalent for resets so we have to parse the gr3d and pcie DT nodes,
> > but that's not too bad I think.
> 
> Even if we could really do this, at this point I don't see an advantage.
> All that it would be doing is move to some subsystem that doesn't quite
> match what we need just for the sake of moving to that subsystem. Having
> a Tegra-specific API doesn't sound so bad anymore.
> 

The advantage would be that we can use LP0/SC7 as a cpuidle state. Also system
resume from LP0 can be faster as we potentially don't have to resume all
domains at once.

Cheers,

Peter.


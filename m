Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaEOKRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:17:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11793 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaEOKRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:17:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 15 May 2014 03:12:14 -0700
Date: Thu, 15 May 2014 13:17:00 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Andrew Bresticker <abrestic@google.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Message-ID: <20140515101700.GH15168@tbergstrom-lnx.Nvidia.com>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo>
 <CAL1qeaGS-78QaiMN-3zXYYXu+K1s7u2rFXQkt7-MRJQS1-sW5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL1qeaGS-78QaiMN-3zXYYXu+K1s7u2rFXQkt7-MRJQS1-sW5A@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 07:58:26PM +0200, Andrew Bresticker wrote:
> On Wed, May 14, 2014 at 7:27 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > As for shared clocks I'm only aware of one use-case, namely EMC scaling.
> > Using clocks for that doesn't seem like the best option to me. While it
> > can probably fix the immediate issue of choosing an appropriate
> > frequency for the EMC clock it isn't a complete solution for the problem
> > that we're trying to solve. From what I understand EMC scaling is one
> > part of ensuring quality of service. The current implementations of that
> > seems to abuse clocks (essentially one X.emc clock per X clock) to
> > signal the amount of memory bandwidth required by any given device. But
> > there are other parts to the puzzle. Latency allowance is one. The value
> > programmed to the latency allowance registers for example depends on the
> > EMC frequency.
> >
> > Has anyone ever looked into using a different framework to model all of
> > these requirements? PM QoS looks like it might fit, but if none of the
> > existing frameworks have what we need, perhaps something new can be
> > created.
> 
> On Exynos we use devfreq, though in that case we monitor performance
> counters to determine how internal buses should be scaled - not sure
> if Tegra SoCs have similar counters that could be used for this
> purpose.  It seems like EMC scaling would fit nicely within the PM QoS
> framework, perhaps with a new PM_QOS_MEMORY_THROUGHPUT class.

We do have counters, however, counters are reactive which is a problem
for some isochronous clients (eg. display). Counters also don't solve
the latency problem.

Cheers,

Peter.

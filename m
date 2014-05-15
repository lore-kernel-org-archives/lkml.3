Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaEOK7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:59:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13108 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaEOK7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:59:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 15 May 2014 03:54:45 -0700
Date: Thu, 15 May 2014 13:59:29 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Message-ID: <20140515105929.GJ15168@tbergstrom-lnx.Nvidia.com>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo>
 <20140514193518.19795.64334@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140514193518.19795.64334@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 09:35:18PM +0200, Mike Turquette wrote:
> Quoting Thierry Reding (2014-05-14 07:27:40)
> > On Tue, May 13, 2014 at 12:09:49PM -0600, Stephen Warren wrote:
> > > On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
> > > > Add shared and cbus clocks to the Tegra124 clock implementation.
> > > 
> > > > diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
> > > 
> > > > +#define TEGRA124_CLK_C2BUS 401
> > > > +#define TEGRA124_CLK_C3BUS 402
> > > > +#define TEGRA124_CLK_GR3D_CBUS 403
> > > > +#define TEGRA124_CLK_GR2D_CBUS 404
> > > ...
> > > 
> > > I worry about this a bit. IIUC, these clocks don't actually exist in HW,
> > > but are more a way of SW applying policy to the clock that do exist in
> > > HW. As such, I'm not convinced it's a good idea to expose these clock
> > > IDS to DT, since DT is supposed to represent the HW, and not be
> > > influenced by internal SW implementation details.
> > > 
> > > Do any DTs actually need to used these new clock IDs? I don't think we
> > > could actually use these value in e.g. tegra124.dtsi's clocks
> > > properties, since these clocks don't exist in HW. Was it your intent to
> > > do that? If not, can't we just define these SW-internal clock IDs in the
> > > header inside the Tegra clock driver, so the values are invisible to DT?
> > 
> > I'm beginning to wonder if abusing clocks in this way is really the best
> > solution. From what I understand there are two problems here that are
> > mostly orthogonal though they're implemented using similar techniques.
> 
> Ack. "Virtual clocks" have been implemented by vendors before as a way
> to manage complicated clock rate changes. I do not think we should
> support such a method upstream.
> 
> I'm working with another engineer in Linaro on a "coordinated clock rate
> change" series that might help solve some of the problems that this
> patch series is trying to achieve.
> 

Any preview? :)

For us to be useful it needs to be possible to:

1) change to a different parent during a rate change
2) adjust a clocks divider when changing parents
3) ignore disabled child clocks
4) have notifiers to hook voltage scaling into

> > 
> > The reason for introducing cbus clocks are still unclear to me. From the
> > cover letter of this patch series it seems like these should be
> > completely hidden from drivers and as such they don't belong in device
> > tree. Also if they are an implementation detail, why are they even
> > implemented as clocks? Perhaps an example use-case would help illustrate
> > the need for this.
> 
> I also have this question. Does "cbus" come from your TRM or data sheet?
> Or is it purely a software solution to coordinating rate changes within
> known limits and for validated combinations?
> 

cbus is a software solution. It's not menioned in any TRM or hardware
document.

Cheers,

Peter.

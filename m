Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbbAGO2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:28:32 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8714 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbbAGO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:28:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Jan 2015 06:27:00 -0800
Date: Wed, 7 Jan 2015 22:28:29 +0800
From: Vince Hsu <vinceh@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150107142828.GB7392@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com> <20150107132709.GA6988@ulmo>
 <20150107140852.GR10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20150107140852.GR10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04:08:52PM Jan 07, Peter De Schrijver wrote:
> On Wed, Jan 07, 2015 at 02:27:10PM +0100, Thierry Reding wrote:
> 
> > > Yeah. I plan to have the information of all the clock client of the
> > > partitions and
> > > the memory clients be defined statically in c source, e.g. pmc-tegra124.c.
> > > All modules can declare which domain they belong to in DT. One domain can
> > > be really power gated only when no module is awake. Note the clock clients
> > > of
> > > one domain might not equal to the clocks of the module. The reset is not
> > > either.
> > > So I don't get the clock and reset from module. How do you think?
> > 
> > This whole situation is quite messy. The above sequence basically means
> > that drivers can't reset hardware modules because otherwise they might
> > race with the power domain code. It also means that we can't powergate
> 
> The powerdomain framework won't call any powergating method as long as a
> module in the domain is still active. So as long as drivers don't try to
> reset the hw without having done a pm_runtime_get(), we shouldn't have such
> a race?
Agree. And as long as the driver has the correct reset procedure, that should
be fine to occur between power ungating and gating sequences.

> 
> > modules on demand because they might be in the same power domain as one
> > other module that's still busy.
> > 
> 
> The powerdomain framework keeps track of which modules are active (by hooking
> into runtime pm) and won't try to shutdown a domain unless all modules are
> inactive.
Yeah. By the way, that means we should start supporting runtime pm for all
the modules to use generic power domain.

Thanks,
Vince

> 
> > How would we handle a situation where a hardware module hangs and we can
> > only get it back via a reset?
> > 
> 
> Cheers,
> 
> Peter.

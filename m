Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaFKQTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:19:09 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12487 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaFKQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:19:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Jun 2014 09:10:17 -0700
Date: Wed, 11 Jun 2014 19:19:02 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140611161901.GI5961@tbergstrom-lnx.Nvidia.com>
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
 <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
 <53984FE3.6010509@nvidia.com>
 <20140611152551.GH5961@tbergstrom-lnx.Nvidia.com>
 <53987CA4.4040506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53987CA4.4040506@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 05:58:28PM +0200, Stephen Warren wrote:
> On 06/11/2014 09:25 AM, Peter De Schrijver wrote:
> > On Wed, Jun 11, 2014 at 02:47:31PM +0200, Mikko Perttunen wrote:
> >> On 05/06/14 16:09, Peter De Schrijver wrote:
> >> ...
> >>> +int tegra_fuse_readl(u32 offset, u32 *val)
> >>> +{
> >>> +       if (!fuse_readl)
> >>> +               return -ENXIO;
> >>> +
> >>> +       *val = fuse_readl(offset);
> >>> +
> >>> +       return 0;
> >>> +}
> >>> +
> >>
> >> -EPROBE_DEFER would be a better error value, so that drivers can work 
> > 
> > Ok.
> > 
> >> even if they are initially probed before the fuse driver. Of course, if 
> >> the fuse initialization is moved into machine init then this is a non-issue.
> > 
> > The exported function will always be initialized later because on Tegra20 it
> > requires APB DMA to be available. If you read the fuses directly, the system
> > sometimes hangs.
> 
> That's not true in the current code. IIRC, the bug was that *if* an APB
> DMA access to anything and a CPU access to the fuses happen at the same
> time, then there can be a hang. As such, the current fuse code accesses
> the fuses directly (without potential for a hang) if the APB DMA driver
> is not available, but once the driver becomes available, it reads the
> fuses through DMA instead. Does the new code not do that?
> 

I'm not so sure about that. I have seen the hang when dumping all fuses using
sysfs in an otherwise idle system booted from initrd. I don't think there
should be any APB DMA activity going on then?

Cheers,

Peter.

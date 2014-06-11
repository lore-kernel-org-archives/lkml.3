Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbaFKPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:25:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5183 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaFKPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:25:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Jun 2014 08:20:37 -0700
Date: Wed, 11 Jun 2014 18:25:51 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140611152551.GH5961@tbergstrom-lnx.Nvidia.com>
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
 <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
 <53984FE3.6010509@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53984FE3.6010509@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:47:31PM +0200, Mikko Perttunen wrote:
> On 05/06/14 16:09, Peter De Schrijver wrote:
> ...
> > +int tegra_fuse_readl(u32 offset, u32 *val)
> > +{
> > +       if (!fuse_readl)
> > +               return -ENXIO;
> > +
> > +       *val = fuse_readl(offset);
> > +
> > +       return 0;
> > +}
> > +
> 
> -EPROBE_DEFER would be a better error value, so that drivers can work 

Ok.

> even if they are initially probed before the fuse driver. Of course, if 
> the fuse initialization is moved into machine init then this is a non-issue.

The exported function will always be initialized later because on Tegra20 it
requires APB DMA to be available. If you read the fuses directly, the system
sometimes hangs.

Cheers,

Peter.

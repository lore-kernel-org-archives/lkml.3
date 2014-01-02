Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaABOcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:32:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15863 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaABOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:32:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 02 Jan 2014 06:33:24 -0800
Date: Thu, 2 Jan 2014 16:32:21 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Danny Huang <dahuang@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>
Subject: Re: [PATCH 4/6] ARM: tegra: rework fuse.c
Message-ID: <20140102143221.GR26588@tbergstrom-lnx.Nvidia.com>
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
 <1387468474-26521-5-git-send-email-pdeschrijver@nvidia.com>
 <CACRpkdbXc_yH-=WgpQyVwHC_TSPfbfx=tHwziNhmB6t0HuSfRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdbXc_yH-=WgpQyVwHC_TSPfbfx=tHwziNhmB6t0HuSfRw@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 01:37:43PM +0100, Linus Walleij wrote:
> On Thu, Dec 19, 2013 at 4:54 PM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> 
> > Reduce fuse.c to the minimum functionality required for the early bootstages.
> > Also export tegra_read_straps() for use by the fuse driver.
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Aha, but why?
> 

The efuse driver in patch 2 of this series, adds the randomness, so we don't
need to add it here then?

> > -static void __init tegra20_fuse_init_randomness(void)
> > -{
> > -       u32 randomness[2];
> > -
> > -       randomness[0] = tegra_fuse_readl(FUSE_UID_LOW);
> > -       randomness[1] = tegra_fuse_readl(FUSE_UID_HIGH);
> > -
> > -       add_device_randomness(randomness, sizeof(randomness));
> > -}
> > -
> > -/* Applies to Tegra30 or later */
> > -static void __init tegra30_fuse_init_randomness(void)
> > -{
> > -       u32 randomness[7];
> > -
> > -       randomness[0] = tegra_fuse_readl(FUSE_VENDOR_CODE);
> > -       randomness[1] = tegra_fuse_readl(FUSE_FAB_CODE);
> > -       randomness[2] = tegra_fuse_readl(FUSE_LOT_CODE_0);
> > -       randomness[3] = tegra_fuse_readl(FUSE_LOT_CODE_1);
> > -       randomness[4] = tegra_fuse_readl(FUSE_WAFER_ID);
> > -       randomness[5] = tegra_fuse_readl(FUSE_X_COORDINATE);
> > -       randomness[6] = tegra_fuse_readl(FUSE_Y_COORDINATE);
> > -
> > -       add_device_randomness(randomness, sizeof(randomness));
> > -}
> 
> We still want to get this into the random pool right? Can it not simply
> be moved to a later initcall then?

Yes, it's done in the efuse driver now, do you think that's too late?

Cheers,

Peter.

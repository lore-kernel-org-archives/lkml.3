Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaIQCYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:24:53 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59218 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaIQCYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:24:52 -0400
Date: Tue, 16 Sep 2014 19:24:40 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
Message-ID: <20140917022440.GA3216@Asurada>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
 <20140916180028.GA6784@Asurada>
 <20140917013251.GA4796@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917013251.GA4796@dragon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:32:52AM +0800, Shawn Guo wrote:
> On Tue, Sep 16, 2014 at 11:19:28AM -0700, Nicolin Chen wrote:
> > On Tue, Sep 16, 2014 at 07:46:34PM +0800, Shengjiu Wang wrote:
> > > The spdif root clock may be used by other module or defined with
> > > CLK_SET_RATE_GATE, so we can't change the clock rate in driver.
> > > In this patch remove the clk_set_rate and clk_round_rate to protect the
> > > clock.
> > 
> > It's a quite convenient and conservative way to remove the clock
> > dealing code in the driver, however, it may result less flexible
> > functionalities.
> > 
> > The reason why I left the clk_set_rate() in the driver is to hope
> > we may find a better way to tackle those tough situations. For IP
> > itself, it doesn't matter if the clock the SoC provides to it is
> > being shared by other modules or not.
> > 
> > So I think, if it's a shared clock, we should not define it as a
> > rate-changeable one in the SoC level, as we might still have some
> > SoCs provide a dedicated clock to S/PDIF so as to get the maximum
> > range of clock support for users.
> > 
> > @Shawn
> > Sorry to involve you in this topic. I'm not so sure if we can do
> > this in the clock driver so that the clock rate would be fixed
> > even if the driver is trying to change it. If we can, I think we
> > may use a better solution here instead.
> 
> No, we do not have anything like that today.

It's not supported in the clock API or just not implemented in our
code? Can we just register a clock without CLK_SET_RATE_PARENT to
achieve the purpose? (We are just trying to fix those PRED and PODF
dividers when the driver calls set_rate to their GATE clock.)

Thank you
Nicolin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3BUI3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:29:52 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:8550 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3BUI3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:29:51 -0500
Date: Thu, 21 Feb 2013 09:29:47 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>,
        Stany MARCEL <smarcel@pactenovation.fr>, Dan Williams <djbw@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH resent] dma: add the freescale-provided MultiChannel
	DMA driver
Message-ID: <20130221082947.GA8799@frolo.macqel>
References: <1359999503-29215-1-git-send-email-phdm@macqel.be> <20130220063147.GD23302@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220063147.GD23302@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Wed, Feb 20, 2013 at 12:01:47PM +0530, Vinod Koul wrote:
> On Mon, Feb 04, 2013 at 06:38:23PM +0100, Philippe De Muyter wrote:
> > This patch adds the (cleaned-up) Freescale-provided MultiChannel DMA
> > driver for ColdFire M54xx and MPC8220 processors.
> > 
> > This driver is needed for the ethernet FEC driver of the ColdFire
> > M547x and M548x processors.
> > 
> > It is not dmaengine-enabled, but that's not needed for the above FEC driver.
> > I have however installed it in the driver/dma tree as this IP block is not
> > m68k-specific, but freescale-specific, and shared at least between powerpc
> > and coldfire parts (possibly arm-parts as well).
> > 
> > The installation in drivers/dma implies a small rule change in
> > drivers/Makefile to enter drivers/dma on CONFIG_DMADEVICES instead
> > of CONFIG_DMAENGINE.
> BIG NAK

Thanks for your answer.

> 1. Please run Checkpath and reread Documentation/CodingStyle, specfically CH4.
> Avoid the CamelCase

I had run checkpatch when I made the patch, but CamelCase was not yet searched
for at that time.  I will look at that.

> 2. If you are not using dmaengine APIs then drivers/dma/ is not a place for you.

What would be the place then for a multi-architecture dma driver.  Freescale often
reuses the same blocks for its m68k (coldfire), powerpc and arm (iMX) product
lines.  A dma driver with many similarities is already under the arch/powerpc
subtree.  I would like to avoid that, because it clearly hurts reusability.

> 3. While glancing at the code, I dont see why you cant use dmaengine APIs?

lack of need (the sole current user of this dma driver is a FEC ethernet driver
which uses the current interface), time and expertise.  but any help is welcome.

> 4. lastly, am blown off by your own implementation of memcpy, WHY? Kernel is
> smarter than you!

I agree, but don't shoot the messenger.  I am not the original author, this is
freescale code.  I only ensured that it compiles and works with current kernels,
and suppressed many checkpatch warnings.

Best regards

Philippe

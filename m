Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3BUJxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:53:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:49801 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3BUJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:53:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,708,1355126400"; 
   d="scan'208";a="288705918"
Date: Thu, 21 Feb 2013 15:22:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>,
        Stany MARCEL <smarcel@pactenovation.fr>, Dan Williams <djbw@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH resent] dma: add the freescale-provided MultiChannel
 DMA driver
Message-ID: <20130221095233.GA8451@intel.com>
References: <1359999503-29215-1-git-send-email-phdm@macqel.be>
 <20130220063147.GD23302@intel.com>
 <20130221082947.GA8799@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221082947.GA8799@frolo.macqel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 09:29:47AM +0100, Philippe De Muyter wrote:
> > 2. If you are not using dmaengine APIs then drivers/dma/ is not a place for you.
> 
> What would be the place then for a multi-architecture dma driver.  Freescale often
> reuses the same blocks for its m68k (coldfire), powerpc and arm (iMX) product
> lines.  A dma driver with many similarities is already under the arch/powerpc
> subtree.  I would like to avoid that, because it clearly hurts reusability.
So the question is will there be any more users of the driver other than the
ethernet one? If No then it should live with ethernet driver.

DMAengine framework should be used where you have a system dma controller used
by different subsystems.
> 
> > 3. While glancing at the code, I dont see why you cant use dmaengine APIs?
> lack of need (the sole current user of this dma driver is a FEC ethernet driver
> which uses the current interface), time and expertise.  but any help is welcome.
> 
> > 4. lastly, am blown off by your own implementation of memcpy, WHY? Kernel is
> > smarter than you!
> I agree, but don't shoot the messenger.  I am not the original author, this is
> freescale code.  I only ensured that it compiles and works with current kernels,
> and suppressed many checkpatch warnings.
Okay but you could have removed these before sending it. Hopefully next version
will have these kind of stuff taken care of :)

--
~Vinod

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3F0Jrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:47:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46691 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0Jrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:47:40 -0400
Date: Thu, 27 Jun 2013 10:46:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Jonathan Austin <jonathan.austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130627094650.GC4283@n2100.arm.linux.org.uk>
References: <51C97F40.5030101@arm.com> <20130625184539.GB2718@n2100.arm.linux.org.uk> <20130626044842.GR23141@intel.com> <20130626081909.GD2718@n2100.arm.linux.org.uk> <20130626103930.GS23141@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626103930.GS23141@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:09:30PM +0530, Vinod Koul wrote:
> On Wed, Jun 26, 2013 at 09:19:09AM +0100, Russell King - ARM Linux wrote:
> > On Wed, Jun 26, 2013 at 10:18:42AM +0530, Vinod Koul wrote:
> > > Yup. This is fixed in slave-dma tree by a patch from mark by renaming it.
> > > 
> > > This should not show in the -next tree
> > 
> > Except, that change probably is probably responsible for this new error:
> > 
> > drivers/dma/amba-pl08x.c: In function 'pl08x_request_mux':
> > drivers/dma/amba-pl08x.c:304:13: error: expected identifier before '(' token
> This was pushed four days ago and havent seen any error report expect this.
> 
> Anyway I rebuild my -next and looks fine for me
> 
>   CC      drivers/dma/dmaengine.o
>   CC      drivers/dma/virt-dma.o
>   CC      drivers/dma/iovlock.o
>   CC [M]  drivers/dma/dmatest.o
>   CC      drivers/dma/amba-pl08x.o
>   LD      drivers/dma/built-in.o
> 
> Can you share your config which failed for you?
> 
> Mark, I believe you are testing for this, have you seen above error?

Right, what's going on is that I have a commit in my tree which adds an
include to asm/pgtable.h which introduces a #define for get_signal.
This becomes visible to amba-pl08x.c.

However, my build test tree fails *every* time because what I'm building
is Linus' tree, my tree plus arm-soc, and it doesn't include your tree.
This makes my build testing for the next merge window impossible.

So, I need the fix to pl08x.c merged into my tree.

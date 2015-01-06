Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbbAFSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:25:07 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:34464 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAFSZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:25:06 -0500
Date: Tue, 6 Jan 2015 20:24:56 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Santosh Shilimkar <ssantosh@kernel.org>,
        Peter =?iso-8859-1?Q?K=FCmmel?= <syntheticpp@gmx.net>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: omap-intc: fix legacy DMA regression
Message-ID: <20150106182456.GG30544@fuloong-minipc.musicnaut.iki.fi>
References: <20150106123830.GD30544@fuloong-minipc.musicnaut.iki.fi>
 <1420563093-26026-1-git-send-email-balbi@ti.com>
 <20150106180532.GO11502@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106180532.GO11502@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 06, 2015 at 06:05:32PM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 06, 2015 at 10:51:33AM -0600, Felipe Balbi wrote:
> > +	 * FIXME legacy OMAP DMA driver sitting under arch/arm/plat-omap/dma.c
> > +	 * depends is still not ready for linear IRQ domains; because of that
> > +	 * we need to temporarily "blacklist" OMAP2 and OMAP3 devices from using
> > +	 * linear IRQ Domain until that driver is finally fixed.
> 
> "finally fixed" or finally killed off like it really needs to be, once
> all users of it are killed.
> 
> We've been trying to do this for, what, three years now... I finally
> pushed a WARN_ON() into that code to make it obvious to anyone who
> uses omap_request_dma() that they really need to update their code.

> Here's the list of references to that symbol which *still* need to be
> fixed so that we can kill the legacy DMA driver:
> 
> drivers/usb/gadget/udc/omap_udc.c:              status = omap_request_dma(dma_channel,
> drivers/usb/gadget/udc/omap_udc.c:              status = omap_request_dma(dma_channel,

I only learned about this after the WARN_ON() appeared in 3.17
(just couple months ago), and it's on my TODO list...

A.

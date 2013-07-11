Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3GKBBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:01:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46724 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754658Ab3GKBBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:01:32 -0400
Date: Wed, 10 Jul 2013 21:01:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
In-Reply-To: <201307110112.57398.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1307102054340.11279-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Arnd Bergmann wrote:

> On Wednesday 10 July 2013, Alan Stern wrote:
> > This isn't right.  There are USB host controllers that use PIO, not
> > DMA.  The HAS_DMA dependency should go with the controller driver, not 
> > the USB core.
> > 
> > On the other hand, the USB core does call various routines like 
> > dma_unmap_single.  It ought to be possible to compile these calls even 
> > when DMA isn't enabled.  That is, they should be defined as do-nothing 
> > stubs.
> 
> The asm-generic/dma-mapping-broken.h file intentionally causes link
> errors, but that could be changed.
> 
> The better approach in my mind would be to replace code like
> 
> 
> 	if (hcd->self.uses_dma)
> 
> with
> 
> 	if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
> 
> which will reliably cause that reference to be omitted from object code,
> but not stop giving link errors for drivers that actually require
> DMA.

How will it give link errors for drivers that require DMA?

Besides, wouldn't it be better to get an error at config time rather
than at link time?  Or even better still, not to be allowed to
configure drivers that depend on DMA if DMA isn't available?

If we add an explicit dependency for HAS_DMA to the Kconfig entries for 
these drivers, then your suggestion would be a good way to allow 
usbcore to be built independently of DMA support.

Alan Stern


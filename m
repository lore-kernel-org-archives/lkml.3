Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3GKPDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:03:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34143 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751197Ab3GKPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:03:52 -0400
Date: Thu, 11 Jul 2013 11:03:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: USB host support should depend on HAS_DMA
In-Reply-To: <CAMuHMdWF8pHQ7RfojiJK7NxULZZjecvzSkP6R+Q-5ib4A516Bw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1307111059220.1276-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Geert Uytterhoeven wrote:

> On Thu, Jul 11, 2013 at 3:01 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 11 Jul 2013, Arnd Bergmann wrote:
> >
> >> On Wednesday 10 July 2013, Alan Stern wrote:
> >> > This isn't right.  There are USB host controllers that use PIO, not
> >> > DMA.  The HAS_DMA dependency should go with the controller driver, not
> >> > the USB core.
> >> >
> >> > On the other hand, the USB core does call various routines like
> >> > dma_unmap_single.  It ought to be possible to compile these calls even
> >> > when DMA isn't enabled.  That is, they should be defined as do-nothing
> >> > stubs.
> >>
> >> The asm-generic/dma-mapping-broken.h file intentionally causes link
> >> errors, but that could be changed.
> >>
> >> The better approach in my mind would be to replace code like
> >>
> >>
> >>       if (hcd->self.uses_dma)
> >>
> >> with
> >>
> >>       if (IS_ENABLED(CONFIG_HAS_DMA) && hcd->self.uses_dma) {
> >>
> >> which will reliably cause that reference to be omitted from object code,
> >> but not stop giving link errors for drivers that actually require
> >> DMA.
> >
> > How will it give link errors for drivers that require DMA?
> 
> It won't. Unless the host driver itself calls into the DMA API, too
> (are there any that don't?).

To my knowledge, all the host controller drivers which use DMA _do_
call functions in the DMA API.  So they would still get link errors,
even though the USB core wouldn't.

Therefore adding the appropriate HAS_DMA dependencies should be 
straightforward: Try to build all the drivers and see which ones fail 
to link.

Alan Stern


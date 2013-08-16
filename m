Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3HPRhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:37:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3HPRhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:37:08 -0400
Date: Fri, 16 Aug 2013 10:37:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/2] xhci:prevent "callbacks suppressed" when debug is
 not enabled
Message-ID: <20130816173707.GA17282@kroah.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
 <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
 <20130816001716.GA7367@kroah.com>
 <20130816172635.GA7975@xanatos>
 <20130816173000.GA8210@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816173000.GA8210@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:30:00AM -0700, Sarah Sharp wrote:
> On Fri, Aug 16, 2013 at 10:26:35AM -0700, Sarah Sharp wrote:
> > On Thu, Aug 15, 2013 at 05:17:16PM -0700, Greg KH wrote:
> > > On Thu, Aug 15, 2013 at 07:04:55PM +0300, Dmitry Kasatkin wrote:
> > > > When debug is not enabled and dev_dbg() will expand to nothing,
> > > > log might be flooded with "callbacks suppressed". If it was not
> > > > done on purpose, better to use dev_dbg_ratelimited() instead.
> > > > 
> > > > Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > > > ---
> > > >  drivers/usb/host/xhci-ring.c | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > 
> > > Sarah, does this patch conflict with the trace debug patches being
> > > worked on?  I'll hold off on applying it for now, let me know if it's ok
> > > or not.
> > 
> > It doesn't conflict with the trace debug patches, because those only
> > effect debugging with xhci_dbg with the host device, not dev_dbg with
> > the USB device.  This should apply fine to usb-next.
> 
> At another glance, the patch removes two if blocks, but doesn't
> re-indent the rest of the lines:
> 
> > @@ -3060,8 +3060,7 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
> >        * to set the polling interval (once the API is added).
> >        */
> >       if (xhci_interval != ep_interval) {
> > -             if (printk_ratelimit())
> > -                     dev_dbg(&urb->dev->dev, "Driver uses different interval"
> > +             dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
> >                                       " (%d microframe%s) than xHCI "
> >                                       "(%d microframe%s)\n",
> >                                       ep_interval,
> 
> That should probably be fixed.

Good catch, the string should also be fixed while the lines are being
touched, to not be split across multiple lines.

Dmitry, can you make that change and resubmit?

thanks,

greg k-h

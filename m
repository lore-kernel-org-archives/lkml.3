Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3HPRak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:30:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3HPRag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:30:36 -0400
Date: Fri, 16 Aug 2013 10:30:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/2] xhci:prevent "callbacks suppressed" when debug is
 not enabled
Message-ID: <20130816173035.GA15607@kroah.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
 <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
 <20130816001716.GA7367@kroah.com>
 <20130816172635.GA7975@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816172635.GA7975@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:26:35AM -0700, Sarah Sharp wrote:
> On Thu, Aug 15, 2013 at 05:17:16PM -0700, Greg KH wrote:
> > On Thu, Aug 15, 2013 at 07:04:55PM +0300, Dmitry Kasatkin wrote:
> > > When debug is not enabled and dev_dbg() will expand to nothing,
> > > log might be flooded with "callbacks suppressed". If it was not
> > > done on purpose, better to use dev_dbg_ratelimited() instead.
> > > 
> > > Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > > ---
> > >  drivers/usb/host/xhci-ring.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > 
> > Sarah, does this patch conflict with the trace debug patches being
> > worked on?  I'll hold off on applying it for now, let me know if it's ok
> > or not.
> 
> It doesn't conflict with the trace debug patches, because those only
> effect debugging with xhci_dbg with the host device, not dev_dbg with
> the USB device.  This should apply fine to usb-next.

Ok, can I get your ack for it so I can apply it?

thanks,

greg k-h

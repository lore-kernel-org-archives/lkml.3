Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAHSTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:19:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:29072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaAHSTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:19:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,625,1384329600"; 
   d="scan'208";a="435864771"
Date: Wed, 8 Jan 2014 10:19:14 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, Shen Guang <shenguang10@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
Message-ID: <20140108181914.GB14082@xanatos>
References: <20140108171548.GA16878@kroah.com>
 <Pine.LNX.4.44L0.1401081249370.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401081249370.1659-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 12:49:57PM -0500, Alan Stern wrote:
> On Wed, 8 Jan 2014, Greg KH wrote:
> 
> > On Wed, Jan 08, 2014 at 02:45:42PM +0800, Shen Guang wrote:
> > > When we are doing compliance test with xHCI, we found that if we
> > > enable CONFIG_USB_SUSPEND and plug in a bad device which causes
> > > over-current condition to the root port, software will not be noticed.
> > > The reason is that current code don't set hub->change_bits in
> > > hub_activate() when over-current happens, and then hub_events() will
> > > not check the port status because it thinks nothing changed.
> > > If CONFIG_USB_SUSPEND is disabled, the interrupt pipe of the hub will
> > > report the change and set hub->event_bits, and then hub_events() will
> > > check what events happened.In this case over-current can be detected.
> > > 
> > > Signed-off-by: Shen Guang <shenguang10@gmail.com>
> > > ---
> > >  drivers/usb/core/hub.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > > index bd9dc35..98b5679 100644
> > > --- a/drivers/usb/core/hub.c
> > > +++ b/drivers/usb/core/hub.c
> > > @@ -1154,7 +1154,8 @@ static void hub_activate(struct usb_hub *hub,
> > > enum hub_activation_type type)
> > >                         /* Tell khubd to disconnect the device or
> > >                          * check for a new connection
> > >                          */
> > > -                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
> > > +                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
> > > +                               (portstatus & USB_PORT_STAT_OVERCURRENT))
> > >                                 set_bit(port1, hub->change_bits);
> > > 
> > >                 } else if (portstatus & USB_PORT_STAT_ENABLE) {
> > > --
> > > 1.7.9.5
> > 
> > Alan and Sarah, any objection to this patch?
> 
> It seems okay to me.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Looks fine to me as well.

Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

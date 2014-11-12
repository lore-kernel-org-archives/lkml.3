Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaKLTwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:52:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44707 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753151AbaKLTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:52:04 -0500
Date: Wed, 12 Nov 2014 14:52:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
cc: Oliver Neukum <oneukum@suse.de>,
        Stephanie Wallick <stephanie.s.wallick@intel.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [V2 PATCH 02/10] added media agnostic (MA) USB HCD roothubs
In-Reply-To: <20141112192819.GB2651@sean.stalley.intel.com>
Message-ID: <Pine.LNX.4.44L0.1411121444300.1676-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Sean O. Stalley wrote:

> > > --- /dev/null
> > > +++ b/drivers/staging/mausb/drivers/mausb_hub.c
> > 
> > > +/**
> > > + * Returns true if the given is the superspeed HCD. Note: The primary HCD is
> > > + * High Speed and the shared HCD is SuperSpeed.
> > > + */
> > 
> > Why in that order?
> > 
> 
> We should probably switch this & make the superspeed hub primary.
> That way we match the xhci driver.

xhci-hcd makes the high-speed hcd the primary one.  This is because it 
registers the high-speed hcd before the SuperSpeed hcd.  There was a 
good reason for doing it this way, but I can't remember what it was 
(it's buried somewhere in the email archives).

That's why when you look at the output from lsusb or something similar,
a SuperSpeed root hub has a bus number that is one higher than its peer
high-speed root hub.

> > > +int mausb_hub_status_data(struct usb_hcd *hcd, char *buf)
> > > +{
> > > +	int                      i;
> > > +	u16                      port_change = 0;
> > > +	u32                      status = 0;
> > > +	int                      ret = 1;
> > > +	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
> > > +	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
> > > +
> > > +	/*
> > > +	 * Buf should never be more that 2 bytes. USB 3.0 hubs cannot have
> > > +	 * more than 15 downstream ports.
> > > +	 */
> > > +	buf[0] = 0;
> > > +	if (MAUSB_ROOTHUB_NUM_PORTS > 7) {
> > > +		buf[1] = 0;
> > > +		ret++;
> > > +	}
> > 
> > Endianness bug.
> > 
> 
> Could you elaborate?
> It was my understanding that this buffer was host-endian.
> Is this an unacceptable way to clear the buffer?

I don't understand Oliver's objection here.  The buffer is 
little-endian, just as it is for real hubs.  The code seems correct.

Alan Stern


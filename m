Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaKLWDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:03:21 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44879 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752009AbaKLWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:03:20 -0500
Date: Wed, 12 Nov 2014 17:03:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
In-Reply-To: <20141112214021.GA3531@sean.stalley.intel.com>
Message-ID: <Pine.LNX.4.44L0.1411121656000.1676-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Sean O. Stalley wrote:

> On Tue, Nov 11, 2014 at 10:54:30AM -0500, Alan Stern wrote:
> > On Mon, 10 Nov 2014, Stephanie Wallick wrote:
> > 
> > > +static struct mausb_hcd mhcd;
> > 
> > Only one statically-allocated structure?  What if somebody wants to 
> > have more than one of these things in their system?
> > 
> 
> Our plan to support multiple MA devices is to have them all connected
> to the same virtual host controller, so only 1 would be needed.
> 
> Would you prefer we have 1 host controller instance per MA device?
> We are definitely open to suggestions on how this should be architected.

I haven't read the MA USB spec, so I don't know how it's intended to 
work.  Still, what happens if you create a virtual host controller 
with, say, 16 ports, and then someone wants to connect a 17th MA 
device?

Also, I noticed that your patch adds a new bus type for these MA host 
controllers.  It really seems like overkill to have a whole new bus 
type if there's only going to be one device on it.

> If we get rid of these locks, endpoints can't run simultaneously.
> MA USB IN endpoints have to copy data, which could take a while.

I don't know what you mean by "run simultaneously".  Certainly multiple 
network packets can be transmitted and received concurrently even if 
you use a single spinlock, since your locking won't affect the 
networking subsystem.

> Couldn't this cause a bottleneck?

Probably not enough to matter.  After all, the other host controller
drivers rely on a single spinlock.  And if it did matter, you could
drop the spinlock while copying the data.

Alan Stern


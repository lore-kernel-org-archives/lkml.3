Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3GJO5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:57:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40890 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752561Ab3GJO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:57:43 -0400
Date: Wed, 10 Jul 2013 10:57:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: host: Use usb_hcd_platform_shutdown() wherever
 possible
In-Reply-To: <51DD1663.60006@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307101051330.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Roger Quadros wrote:

> On 07/09/2013 05:16 PM, Alan Stern wrote:
> > On Tue, 9 Jul 2013, Roger Quadros wrote:
> > 
> >> Most HCD drivers are doing the same thing in their ".shutdown" callback
> >> so it makes sense to use the generic usb_hcd_platform_shutdown()
> >> handler there.
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>  drivers/usb/host/ehci-grlib.c     |   11 +----------
> >>  drivers/usb/host/ehci-mxc.c       |   10 +---------
> >>  drivers/usb/host/ehci-omap.c      |   10 +---------
> >>  drivers/usb/host/ehci-ppc-of.c    |   11 +----------
> >>  drivers/usb/host/ehci-s5p.c       |   10 +---------
> >>  drivers/usb/host/ehci-tegra.c     |   10 +---------
> >>  drivers/usb/host/ehci-xilinx-of.c |   17 +----------------
> >>  drivers/usb/host/ohci-omap3.c     |   10 +---------
> >>  8 files changed, 8 insertions(+), 81 deletions(-)
> > 
> > This all looks fine.  But unless my kernel tree is out of date, you 
> > missed ohci-ppc-of.c.
> 
> You are right. I missed it and will send a revision.
> 
> I've also noticed some drivers doing non-standard stuff.
> e.g.
> - ehci-ps3.c and ohci-pst set .shutdown as well as .remove to to ps3_ehci_remove

I don't know why they do that.  There not be any good reason.  You 
could try asking the PS3 platform maintainer.

> - ehci-tilegx.c and ohci-tilegx call .remove in the .shutdown path

Again, I don't know why.  The TILE architecture maintainer might know.

> - ehci-mv.c checks for (!hcd->rh_registered) in the shudown & remove patch.
> Is this necessary?

I suspect this is because the driver is trying to cope with switching
between host mode and device (peripheral) mode.  This doesn't seem like
a good way to implement OTG, but until it gets changed we'll have to
live with the driver the way it is.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3GCOae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:30:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49923 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752578Ab3GCOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:30:32 -0400
Date: Wed, 3 Jul 2013 10:30:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <20130703131513.GH15056@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1307031023060.1241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Felipe Balbi wrote:

> On Wed, Jul 03, 2013 at 04:06:04PM +0300, Roger Quadros wrote:
> > On 07/03/2013 03:57 PM, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Tue, Jul 02, 2013 at 01:17:58PM -0400, Alan Stern wrote:
> > >> A PCI-based EHCI controller has two power sources: the core well (which
> > >> is turned off during suspend) and the auxiliary well (which remains
> > >> powered).  That's how remote wakeup works; it uses the auxiliary well.
> > > 
> > > This, kinda, matches what OMAP tries to do with pad wakeup. Just that
> > > pad wakeup sits outside of the device itself. Perhaps we could look into
> > > how PCI handles the aux well and take some inspiration from there.
> > > 
> > > Any pointers under drivers/pci/ would be great :-)
> > > 
> > From what I understood, auxiliary well is just a power source, and it keeps
> > the EHCI controller powered even during suspend.
> > 
> > If that is true then it is different from our situation as we power down the
> > EHCI controller completely.
> 
> right but our "auxiliary well" keeps PRCM powered which can wake EHCI up
> ;-)
> 
> What I'm saying is that from ehci-omap's perspective, there's very
> little difference, specially since we route the wakeup through the same
> IRQ line anyway. Perhaps we could take some inspiration from the PCI
> land to make our hwmod/omap_device a little easier from driver
> perspective.
> 
> Or maybe it doesn't make sense ;-)

This idea probably won't lead anywhere.  To the best of my knowledge 
(and I'm not an expert on PCI), these different power wells are simply 
part of the PCI bus.  The bus controller knows to turn off one of them 
when the device (or maybe when all the devices on a bus segment) goes 
into D3.

One big difference with respect to OMAP is the way PCI handles wakeup
messages.  There's a separate bus signal, PME# (which stands for Power
Management Event), that a device asserts when it wants to send a wakeup
request.  When the ACPI driver sees the PME# signal, it searches
through the entire PCI tree to find the device or devices which need to
be resumed.  Or maybe when ACPI sees the signal, it tells the PCI core 
to do this -- I'm not sure of the details.

Alan Stern


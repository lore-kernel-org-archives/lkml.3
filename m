Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaFEOVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:21:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751140AbaFEOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:21:21 -0400
Date: Thu, 5 Jun 2014 10:21:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Chen <Peter.Chen@freescale.com>
cc: "Yang,Wei" <Wei.Yang@windriver.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <82bb5df19e9047298f4e80aa870cceec@BL2PR03MB226.namprd03.prod.outlook.com>
Message-ID: <Pine.LNX.4.44L0.1406051018580.1103-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Peter Chen wrote:

> > > > It is a little strange we call gadget's disconnect at SET_ADDRESS?
> > > > How the udc calls gadget driver the disconnection has happened when
> > > > the usb cable is disconnected from the host?
> > > >
> > > > Usually, we call gadget's disconnect at two situations
> > > >
> > > > - udc's reset handler if udc's speed is not UNKNOWN, it is usually
> > > > happened when the host sends reset after enumeration.
> > > > - udc's disconnect handler, it is usually happened when the usb
> > > > cable is disconnected from host.
> > >
> > > Hmm, usually the two situations, but according to the commit log, s3c
> > > hsotg does not support Disconnected interrupt for device mode, so the
> > > second situation does not happen for s3c hsotg, therefore, he has to
> > > disconnect the connection before it is connected again.
> > 
> > Why does he need to do that?  Why not just skip the disconnect
> > notification if the hardware can't detect a disconnect?
> > 
> 
> We must call gadget driver's disconnect, otherwise, there at least
> has a warning when unload module, please refer to __composite_unbind
> at drivers/usb/gadget/composite.c

The disconnect callback can run just before unbind.  That's not a valid
reason for doing a disconnect notification as part of SET_ADDRESS.

Alan Stern


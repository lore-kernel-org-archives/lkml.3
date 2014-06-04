Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaFDN4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:56:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45323 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752800AbaFDN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:56:37 -0400
Date: Wed, 4 Jun 2014 09:56:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Yang,Wei" <Wei.Yang@windriver.com>
cc: Peter Chen <Peter.Chen@freescale.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <538E8F70.2010600@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1406040953400.15745-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Yang,Wei wrote:

> On 06/04/2014 09:45 AM, Peter Chen wrote:
> >   
> >> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> >> Author: Robert Baldyga <r.baldyga@samsung.com>
> >> Date:   Thu Nov 21 13:49:18 2013 +0100
> >>
> >>       usb: gadget: s3c-hsotg: fix disconnect handling
> >>
> >>       This patch moves s3c_hsotg_disconnect function call from USBSusp
> >> interrupt
> >>       handler to SET_ADDRESS request handler.
> >>
> > It is a little strange we call gadget's disconnect at SET_ADDRESS?
> > How the udc calls gadget driver the disconnection has happened when
> > the usb cable is disconnected from the host?
> >
> > Usually, we call gadget's disconnect at two situations
> >
> > - udc's reset handler if udc's speed is not UNKNOWN, it is usually happened
> > when the host sends reset after enumeration.
> > - udc's disconnect handler, it is usually happened when the usb cable
> > is disconnected from host.
> 
> Hmm, usually the two situations, but according to the commit log, s3c 
> hsotg does not support Disconnected interrupt for device mode,
> so the second situation does not happen for s3c hsotg, therefore, he has 
> to disconnect the connection before it is connected again.

Why does he need to do that?  Why not just skip the disconnect 
notification if the hardware can't detect a disconnect?

It makes no sense at all to call a disconnect handler from within the 
SET_ADDRESS routine.

Alan Stern


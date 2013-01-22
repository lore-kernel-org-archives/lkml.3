Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3AVPTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:19:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34823 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753073Ab3AVPTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:19:07 -0500
Date: Tue, 22 Jan 2013 10:19:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
In-Reply-To: <CAJFYCKFb8F1k5Y6+Q4x5WgTsLO_xh1AFB1mgyRc0xK5m1ABbwA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301221011190.1510-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Manjunath Goudar wrote:

> > >  I think we can actually
> > > get the same results by turning the Kconfig logic around and making
> > > the platform glue drivers 'select USB_EHCI_HCD' than depending on
> > > it.
> >
> > That's a good idea.  The Kconfig changes would have to be done
> > carefully to make sure that the dependency on USB_ARCH_HAS_EHCI still
> > applies to all the platform drivers.
> >
> > Manjunath, would you like to send a patch to do this?
> >
> > Alan Stern
> >
> > Ya sure,could you explain little bit  briefly about the Kconfig changes.

Suppose you do exactly what Arnd proposed: add "select USB_EHCI_HCD" to
the Kconfig entries for each of the platform glue drivers.  Then
consider what would happen in a build where USB_ARCH_HAS_EHCI is "n"
but one of those glue drivers is enabled.  There would be conflicting
requirements on USB_EHCI_HCD: The new "select" would force it to be on,
but the existing "depends on USB && USB_ARCH_HAS_EHCI" would force it
to be off.  The build would fail.

In order to prevent this, you have to make sure that each glue driver
depends on USB_ARCH_HAS_EHCI.  A simple way to do this is to surround
the Kconfig entries for those drivers with "if USB && 
USB_ARCH_HAS_EHCI" ... "endif".

Come to think of it, the "if USB" part really should protect the entire 
file.

Alan Stern


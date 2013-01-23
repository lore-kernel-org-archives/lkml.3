Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3AWPWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:22:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752867Ab3AWPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:22:49 -0500
Date: Wed, 23 Jan 2013 10:22:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Arnd Bergmann <arnd@arndb.de>,
        Manjunath Goudar <manjunath.goudar@linaro.org>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
In-Reply-To: <20130122210027.GN1906@pengutronix.de>
Message-ID: <Pine.LNX.4.44L0.1301231018390.2045-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Sascha Hauer wrote:

> On Tue, Jan 22, 2013 at 03:38:55PM +0000, Arnd Bergmann wrote:
> > On Tuesday 22 January 2013, Alan Stern wrote:
> > > In order to prevent this, you have to make sure that each glue driver
> > > depends on USB_ARCH_HAS_EHCI.  A simple way to do this is to surround
> > > the Kconfig entries for those drivers with "if USB && 
> > > USB_ARCH_HAS_EHCI" ... "endif".
> > 
> > I was actually thinking we could remove the use of USB_ARCH_HAS_EHCI
> > as well once we have inverted the logic for selecting USB_EHCI_HCD,
> > but there is another problem with that, because then we still need
> > something to select USB_ARCH_HAS_HCD, or kill that symbol as well.
> 
> +1 for killing it. Such symbols get more and more meaningless anyway
> with multiarch kernels-

I tend to agree.  Anyway, the symbols are named badly.  _Any_
architecture with HAS_IOMEM can in theory aupport host-side USB.  
Maybe some of the platforms don't, but that has nothing to do with the
CPU's architecture.

Furthermore, even platforms that don't support USB host controllers 
can use things like dummy-hcd and usbip, which provide virtual host 
controllers.

Anybody think these symbols should be retained?

Alan Stern


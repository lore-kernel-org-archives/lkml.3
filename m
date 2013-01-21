Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3AUUL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:11:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40135 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752699Ab3AUUL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:11:57 -0500
Date: Mon, 21 Jan 2013 15:11:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
In-Reply-To: <20130121184237.GC10106@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1301211459550.24224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Felipe Balbi wrote:

> On Mon, Jan 21, 2013 at 05:16:06PM +0000, Arnd Bergmann wrote:
> > In linux-3.8-rc1 it became possible to build the imx and
> > mvebu platforms together in a single kernel, which clashes
> > in the ehci driver.
> > 
> > Manjunath Goudar is already working on a patch to convert
> > both the imx and the mvebu glue drivers (along with all
> > the other ARM specific ones) to the new probing method,
> > but that will be too late to fix v3.8. This patch instead
> > adds yet another hack like the existing ones to allow
> > the ehci driver to load both back-ends.

Pardon me for being confused.  Is this about imx and mvebu (as 
mentioned here) or about orion and mxc (as described in the patch 
title, the error messages below, and the patch itself)?

> > Without this patch, building allyesconfig results in:
> > 
> > drivers/usb/host/ehci-hcd.c:1285:0: error: "PLATFORM_DRIVER" redefined
> > drivers/usb/host/ehci-hcd.c:1255:0: note: this is the location of the previous definition
> > In file included from drivers/usb/host/ehci-hcd.c:1254:0:
> > drivers/usb/host/ehci-mxc.c:280:31: warning: 'ehci_mxc_driver' defined but not used

Was the point here to fix the build error or to allow the two drivers
to coexist?  The first would be eaiser than the second.

> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-usb@vger.kernel.org
> > Cc: Manjunath Goudar <manjunath.goudar@linaro.org>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Gregory Clement <gregory.clement@free-electrons.com>
> 
> NAK, should be converted to the new usage of ehci library driver. Alan
> Stern already implemented for a few drivers, help is very welcome.

Arnd, please take a look at

	http://marc.info/?l=linux-usb&m=135843716515529&w=2

I can't test it easily, not being set up for cross compilation.  I'm 
waiting to hear from anybody whether it works before submitting it.
(There's also a report of memory corruption involving a similar patch 
for ehci-omap; it hasn't been tracked down yet.)

Alan Stern


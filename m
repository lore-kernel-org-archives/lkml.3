Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3AVVAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:00:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48120 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3AVVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:00:43 -0500
Date: Tue, 22 Jan 2013 22:00:27 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Manjunath Goudar <manjunath.goudar@linaro.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Message-ID: <20130122210027.GN1906@pengutronix.de>
References: <Pine.LNX.4.44L0.1301221011190.1510-100000@iolanthe.rowland.org>
 <201301221538.55975.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301221538.55975.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:59:35 up 213 days, 12:11, 51 users,  load average: 0.11, 0.18,
 0.22
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:38:55PM +0000, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Alan Stern wrote:
> > In order to prevent this, you have to make sure that each glue driver
> > depends on USB_ARCH_HAS_EHCI.  A simple way to do this is to surround
> > the Kconfig entries for those drivers with "if USB && 
> > USB_ARCH_HAS_EHCI" ... "endif".
> 
> I was actually thinking we could remove the use of USB_ARCH_HAS_EHCI
> as well once we have inverted the logic for selecting USB_EHCI_HCD,
> but there is another problem with that, because then we still need
> something to select USB_ARCH_HAS_HCD, or kill that symbol as well.

+1 for killing it. Such symbols get more and more meaningless anyway
with multiarch kernels-

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

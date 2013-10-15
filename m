Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab3JOOqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:46:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58526 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759171Ab3JOOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:46:38 -0400
Date: Tue, 15 Oct 2013 10:46:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hartley Sweeten <HartleyS@visionengravers.com>
cc: Ryan Mallon <rmallon@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817DAC0CC@P3PWEX4MB008.ex4.secureserver.net>
Message-ID: <Pine.LNX.4.44L0.1310151040330.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, Hartley Sweeten wrote:

> >>  config USB_OHCI_HCD_PLATFORM
> >>  	tristate "Generic OHCI driver for a platform device"
> >> -	default n
> >> +	default y if ARCH_EP93XX
> >
> > Shouldn't we select USB_OHCI_HCD_PLATFORM, e.g. something like:
> >
> > 	config ARCH_EP93XX_USB
> >		tristate "USB OHCI support"
> >		default y
> >		select USB_OHCI_HCD_PLATFORM
> >
> > In arch/arm/mach-ep93xx/Kconfig rather than polluting
> > drivers/usb/host/Kconfig with arch specific stuff?
> 
> I wasn't sure where the best place to enable 
> USB_OHCI_HCD_PLATFORM would be.
> 
> Currently USB support on the EP93xx only needs USB_OHCI_HCD
> enabled, which is already enabled in the ep93xx_defconfig. I'm not
> sure if adding the config option above would create a problem where
> the user would need to enable USB_OHCI_HCD in drivers/usb then 
> have to go back to the arch stuff to enable ARCH_EP93XX_USB.
> 
> With the default y above they just have to enable USB_OHCI_HCD
> like they currently do.
> 
> I'm hoping Alan can provide some feedback.

In the past this sort of thing has been done in two different ways, 
depending on whether or not OHCI support was previously configurable.

In cases where it was, we kept the old Kconfig entry and made it select
USB_OHCI_HCD_PLATFORM, but added a notice that the entry was now
deprecated.  For example, in drivers/usb/host/Kconfig see the entry for
USB_OHCI_ATH79.

In cases where support was always present (i.e., not configurable), we
added an entry for USB_OHCI_HCD_PLATFORM to the platform's defconfig
file.  For example, see arch/arm/configs/marzen_defconfig.  This is
probably what you want to do.

Alan Stern


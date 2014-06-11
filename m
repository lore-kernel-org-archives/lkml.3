Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaFKUpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:45:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42751 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751797AbaFKUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:45:05 -0400
Date: Wed, 11 Jun 2014 16:45:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <julia.lawall@lip6.fr>
cc: Himangi Saraogi <himangi774@gmail.com>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] uhci-platform: use devm_ioremap resource
In-Reply-To: <alpine.DEB.2.10.1406112038420.2576@hadrien>
Message-ID: <Pine.LNX.4.44L0.1406111639420.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Julia Lawall wrote:

> > > v2: pass correct arguments to devm_ioremap_resource
> > > Not compile tested due to incompatible architecture.
> >
> > uhci-platform is compatible with all architectures.  But you have to
> > add it to the .config file by hand.
> 
> What should one do exactly?  I added
> 
> CONFIG_USB_UHCI_PLATFORM=y
> 
> to the end of my .config file, but then running make just overwrites it:

By golly, you're right...  I didn't realize it would do that.

I guess you have to edit the drivers/usb/host/Kconfig file, changing

config USB_UHCI_PLATFORM
	bool
	default y if ARCH_VT8500

to

config USB_UHCI_PLATFORM
	bool
	default y

or something equivalent.

> 
> > make drivers/usb/host/uhci-platform.o
> scripts/kconfig/conf --silentoldconfig Kconfig
> #
> # configuration written to .config
> #
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/usb/host/uhci-platform.o
> drivers/usb/host/uhci-platform.c:13:38: warning: ¡struct usb_hcd¢ declared
> inside parameter list [enabled by default]
>  static int uhci_platform_init(struct usb_hcd *hcd)

Do

	make drivers/usb/host/uhci-hcd.o

instead of

	make drivers/usb/host/uhci-platform.o

Alan Stern


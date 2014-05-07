Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbaEGKXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:23:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932180AbaEGKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:23:29 -0400
Date: Wed, 7 May 2014 12:23:26 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: <balbi@ti.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140507122326.54f3febc@free-electrons.com>
In-Reply-To: <20140506153953.GF25849@saruman.home>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
	<20140506153953.GF25849@saruman.home>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Felipe Balbi,

On Tue, 6 May 2014 10:39:53 -0500, Felipe Balbi wrote:

> >  config USB_EHCI_HCD
> > diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> > index 7530468c9a4f..7a8db7f7dc01 100644
> > --- a/drivers/usb/host/Makefile
> > +++ b/drivers/usb/host/Makefile
> > @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+= xhci-pci.o
> >  
> >  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> >  	xhci-hcd-y		+= xhci-plat.o
> > +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+= xhci-mvebu.o
> 
> hmm, this has the potential of resulting in:
> 
> 	xhci-hcd-m += xhci-mvebu.o
> 
> I guess it's best to turn this into:
> 
> ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> 	xhci-hcd-y += xhci-mvebu.o
> endif

I guess you meant:

ifneq ($(CONFIG_USB_XHCI_MVEBU), )
	xhci-hcd-y += xhci-mvebu.o
endif

Right?

If so, then what about instead making CONFIG_USB_XHCI_MVEBU a bool
instead of a tristate? It's more an option for the xhci-platform
driver than an additional separate module, IMO. What do you think?

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

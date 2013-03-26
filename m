Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3CZTIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:08:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753725Ab3CZTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:08:38 -0400
Date: Tue, 26 Mar 2013 15:08:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Florian Fainelli <florian@openwrt.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC PATCH 2/5] USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO}
 depends on architecture symbol
In-Reply-To: <201303261810.44154.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1303261506500.999-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Arnd Bergmann wrote:

> On Tuesday 26 March 2013, Florian Fainelli wrote:
> > 
> > Just like the OHCI counter part we just can remove the architecture
> > specific symbols which prevent these configuration symbols from being
> > selected by platforms/architectures requiring it. The original
> > implementation did not scale at all since it required each and every
> > single architecture to be added for these configuration symbols to be
> > selected. Now it is up to the EHCI driver and/or platform to select
> > these configuration symbols accordingly.
> > 
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> 
> Good idea, just one suggestion:
> 
> >  config USB_EHCI_BIG_ENDIAN_MMIO
> >         bool
> > -       depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
> > -                                   ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
> > -                                   PPC_MPC512x || CPU_CAVIUM_OCTEON || \
> > -                                   PMC_MSP || SPARC_LEON || MIPS_SEAD3)
> > -       default y
> > +       depends on USB_EHCI_HCD
> > +       default n
> >  
> >  config USB_EHCI_BIG_ENDIAN_DESC
> >         bool
> > -       depends on USB_EHCI_HCD && (440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
> > -                                   PPC_MPC512x || PMC_MSP || SPARC_LEON || \
> > -                                   MIPS_SEAD3)
> > -       default y
> > +       depends on USB_EHCI_HCD
> > +       default n
> >  
> >  config XPS_USB_HCD_XILINX
> >         bool "Use Xilinx usb host EHCI controller core"
> 
> You can drop the "default n" line as well, it's the default.

The "depends on USB_EHCI_HCD" isn't really needed either.  The build 
system might get confused if platform code selects 
USB_EHCI_BIG_ENDIAN_DESC but for some reason USB_EHCI_HCD isn't 
enabled.

Alan Stern


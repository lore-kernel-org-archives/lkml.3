Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbaE2PoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:44:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42622 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757468AbaE2PoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:44:15 -0400
Date: Thu, 29 May 2014 11:44:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lugovskoy@dev.rtsoft.ru>
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
In-Reply-To: <53875339.7050408@dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1405291139000.1285-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Nikita Yushchenko wrote:

> 29.05.2014 18:42, One Thousand Gnomes пишет:
> >> I don't know how linux usb subsystem should behave against such
> >> "half-existing" hardware. Perhaps hanging is not the best idea...
> >> but maybe it should be fixed elsewhere, e.g. by masking non-wired
> >> devices in platform PCI setup. Perhaps controlled by some device-tree
> >> key.
> > 
> > Does it have a unique svid/sdid set for the platform - if so you could
> > just blacklist that combination of vid/did/svid/sdid.
> 
> Unfortunately vid/did/svid/sdid come from ULI 1553 southbridge chip,
> that is used by other hardware as well. AFAIK it is still being
> manufactured, and could appear in PCs or laptops.

> > It would help to print the value of fminterval.
> > And here to print the value obtained by the readl().
>
> I've checked these... all values read as 0xffffffff - which does not
> look correct

You could have the platform setup code read one of those hardware
registers, such as FMINTERVAL.  If it obtains 0xffffffff, don't
register the OHCI controller as a platform device.

Alan Stern


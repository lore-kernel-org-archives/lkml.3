Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaE2RQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:16:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42668 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757938AbaE2RQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:16:19 -0400
Date: Thu, 29 May 2014 13:16:18 -0400 (EDT)
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
In-Reply-To: <5387562B.8070809@dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1405291313550.1285-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Nikita Yushchenko wrote:

> >> I've checked these... all values read as 0xffffffff - which does not
> >> look correct
> > 
> > You could have the platform setup code read one of those hardware
> > registers, such as FMINTERVAL.  If it obtains 0xffffffff, don't
> > register the OHCI controller as a platform device.
> 
> It is not a platform_device, it is PCI device that is found via bus scan.

Yes, of course, I got it mixed up.

Well, the quirk_usb_handoff_ohci() routine could do something like 
this.  If the FMINTERVAL value is 0xffffffff, deregister the device 
from the PCI bus.

Alan Stern


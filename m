Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaCGPST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:18:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42540 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753219AbaCGPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:18:16 -0500
Date: Fri, 7 Mar 2014 10:18:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Laight <David.Laight@ACULAB.COM>
cc: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] Revert "USBNET: ax88179_178a: enable tso if usb host
 supports sg dma"
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6D770F@AcuExch.aculab.com>
Message-ID: <Pine.LNX.4.44L0.1403071016450.1246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014, David Laight wrote:

> From: Mathias Nyman
> > This reverts commit 3804fad45411b48233b48003e33a78f290d227c8.
> > 
> > This commit, together with commit 247bf557273dd775505fb9240d2d152f4f20d304
> > "xhci 1.0: Limit arbitrarily-aligned scatter gather." were
> > origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
> > working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
> > buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
> > storage devices to fail more frequently.
> 
> This patch doesn't need to be reverted.

Yes, it does.

> Provided the xhci driver doesn't set the flag to say that arbitrary scatter
> gather is supported (ie usb_device_no_sg_constraint(dev->udev)) is false)
> the ax88179_178a driver won't request transmits that need fragmenting.

True.  But xhci-hcd _will_ set the flag, because of patch 1 in this 
series.  In other words, patch 1 makes patch 2 necessary.

Alan Stern


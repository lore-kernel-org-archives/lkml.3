Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaDOTOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:14:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42687 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751331AbaDOTOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:14:47 -0400
Date: Tue, 15 Apr 2014 15:14:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1397588786.21892.4.camel@vger.seibold.net>
Message-ID: <Pine.LNX.4.44L0.1404151512030.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Stefani Seibold wrote:

> > > usbcore: registered new interface driver USB-SATA-storage
> > > USB SATA Mass Storage support registered.
> > > usb 1-4: new high-speed USB device number 4 using ehci-pci
> > > xxxx: ports detected
> > 
> > What driver is this?  I've never heard of USB-SATA-storage.
> > 
> 
> This is a special embedded USB SATA driver written by me. It is mostly a
> fork of the usb-storage driver but handle only one vendor and product ID
> and does switch on a port bit. On the other side this vendor and product
> ID is black listed in the regular usb-storage driver. 

Is it possible that your driver leaves the device in a strange state 
where it won't initialize properly?

You can test this by blacklisting both mass-storage drivers.  If the 
device then initializes properly after unbind and rebind, you'll know 
the answer.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaDOTFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:05:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42680 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752699AbaDOTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:05:20 -0400
Date: Tue, 15 Apr 2014 15:05:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-usb <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1397586749.20840.6.camel@vger.seibold.net>
Message-ID: <Pine.LNX.4.44L0.1404151502160.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Stefani Seibold wrote:

> > One other thing you can try is to increase the reset timeout in 
> > drivers/usb/host/ehci-hub.c.  This is under the USB_PORT_FEAT_RESET 
> > case in ehci_hub_control(), around line 1225:
> > 
> > 				/*
> > 				 * caller must wait, then call GetPortStatus
> > 				 * usb 2.0 spec says 50 ms resets on root
> > 				 */
> > 				ehci->reset_done [wIndex] = jiffies
> > 						+ msecs_to_jiffies (50);
> > 
> > Increasing the 50 to 100 or more might help.
> > 
> > Alan Stern
> > 
> 
> I tried this, when i increase the value to 1000, the reset and
> enumeration process will be faster after a kexec: 28 Seconds vs. 162
> Seconds.

Even 28 seconds is much longer than it should be.  And a 1000-ms long 
reset signal is a lot longer than any device should need.

Anyway, since you saw the same problem after unbind and rebind, you 
don't have to perform a kexec for testing.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaDNR6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:58:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42817 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754311AbaDNR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:58:22 -0400
Date: Mon, 14 Apr 2014 13:58:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-usb <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1397493335.1028.4.camel@vger.seibold.net>
Message-ID: <Pine.LNX.4.44L0.1404141354360.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Stefani Seibold wrote:

> > > An other PowerPC device which is nearly eactly the same HW but without  
> > > this USB HUB works perfectly.
> > 
> > Maybe you should replace that hub with a different brand.
> > 
> 
> Thats not possible, because the Hub is soldered on the board. And it is
> also not a HW issue, since the Hub works perfectly which all previous
> kernels including 3.4.

One other thing you can try is to increase the reset timeout in 
drivers/usb/host/ehci-hub.c.  This is under the USB_PORT_FEAT_RESET 
case in ehci_hub_control(), around line 1225:

				/*
				 * caller must wait, then call GetPortStatus
				 * usb 2.0 spec says 50 ms resets on root
				 */
				ehci->reset_done [wIndex] = jiffies
						+ msecs_to_jiffies (50);

Increasing the 50 to 100 or more might help.

Alan Stern


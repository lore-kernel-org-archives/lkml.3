Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaDOSdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:33:21 -0400
Received: from www84.your-server.de ([213.133.104.84]:52668 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaDOSdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:33:19 -0400
Message-ID: <1397586749.20840.6.camel@vger.seibold.net>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, sarah.a.sharp@linux.intel.com,
        andreas.brief@rohde-schwarz.com
Date: Tue, 15 Apr 2014 20:32:29 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404141354360.874-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404141354360.874-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 14.04.2014, 13:58 -0400 schrieb Alan Stern:
> On Mon, 14 Apr 2014, Stefani Seibold wrote:
> 
> > > > An other PowerPC device which is nearly eactly the same HW but without  
> > > > this USB HUB works perfectly.
> > > 
> > > Maybe you should replace that hub with a different brand.
> > > 
> > 
> > Thats not possible, because the Hub is soldered on the board. And it is
> > also not a HW issue, since the Hub works perfectly which all previous
> > kernels including 3.4.
> 
> One other thing you can try is to increase the reset timeout in 
> drivers/usb/host/ehci-hub.c.  This is under the USB_PORT_FEAT_RESET 
> case in ehci_hub_control(), around line 1225:
> 
> 				/*
> 				 * caller must wait, then call GetPortStatus
> 				 * usb 2.0 spec says 50 ms resets on root
> 				 */
> 				ehci->reset_done [wIndex] = jiffies
> 						+ msecs_to_jiffies (50);
> 
> Increasing the 50 to 100 or more might help.
> 
> Alan Stern
> 

I tried this, when i increase the value to 1000, the reset and
enumeration process will be faster after a kexec: 28 Seconds vs. 162
Seconds.

- Stefani


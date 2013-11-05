Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3KEPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:41:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43132 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754292Ab3KEPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:41:47 -0500
Date: Tue, 5 Nov 2013 10:41:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
In-Reply-To: <52790A97.4040408@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1311051039250.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, David Cohen wrote:

> >> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
> >> +{
> >> +	int aligned;
> >> +
> >> +	if (ep->desc->bmAttributes & USB_ENDPOINT_XFER_INT)
> >> +		/*
> >> +		 * Interrupt eps don't need max packet size to be power of 2,
> >> +		 * so can't use cheap IS_ALIGNED() macro.
> >> +		 */
> >> +		aligned = !(len % ep->desc->wMaxPacketSize);
> >> +	else
> >> +		aligned = IS_ALIGNED(len, ep->desc->wMaxPacketSize);
> > 
> > This isn't on a hot path, and I suspect that the extra "if" will 
> > require nearly as much time as you save by not doing the division.  You 
> > might as well always use the % operation.
> 
> Perhaps if I use unlikely() on 'if' condition instead?
> Anyway I'll double check the costs of if + IS_ALIGNED vs modulo.

You're missing the point.  You and I (not to mention anybody who ever
reads this code in the future) have already wasted more time talking
about it and trying to understand it than you will ever save by using
IS_ALIGNED.

The difference to the computer is minimal at best.  Make things easier 
for the programmers.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3J3PXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:23:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53815 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751615Ab3J3PXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:23:40 -0400
Date: Wed, 30 Oct 2013 11:23:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Laight <David.Laight@ACULAB.COM>
cc: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73C1@saturn3.aculab.com>
Message-ID: <Pine.LNX.4.44L0.1310301119190.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, David Laight wrote:

> > Wouldn't it be simpler and safer to just do this unconditionally? Sure,
> > you need it for DWC3 because the controller refuses to do an OUT transfer
> > at all if the transfer size is less than maxpacketsize. But it's possible
> > that other controllers allow the transfer, and it works in most cases,
> > but if an error occurs and the host sends too much data, they could
> > overrun the buffer and crash your device.
> > 
> > For example, the DWC2 databook says "For OUT transfers, the Transfer
> > Size field in the endpoint's Transfer Size register must be a multiple
> > of the maximum packet size of the endpoint". But I don't think the
> > controller enforces that, it is up to the programmer to do the right
> > thing. So that controller probably needs this quirk also. There could be
> > more like that which we don't know about.
> > 
> > So unless the buffer allocation code is in a real fast path, I would
> > suggest to just do the aligned buffer allocation always.
> 
> You wouldn't normally want to pad OUT transfers that way - if only
> because of the additional USB bandwidth use.

What additional bandwidth use?  Allocating more memory doesn't mean any
additional data will be transmitted over the USB bus.

> Also, if the controller can't do (I assume bulk) OUT (and IN?)
> transfers for less than maxpacketsize it seriously restricts
> the type of devices that can be attached - none of the USB
> ethernet devices would work.

The controllers _are_ capable of doing shorter transfers.  You are
missing the point: These are device controllers, not host controllers,
so they don't have any choice about the length of an OUT transfer.

Alan Stern


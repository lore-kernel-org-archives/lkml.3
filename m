Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaGBOfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:35:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49375 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752091AbaGBOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:35:22 -0400
Date: Wed, 2 Jul 2014 10:35:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
In-Reply-To: <1404291956.12021.23.camel@x220>
Message-ID: <Pine.LNX.4.44L0.1407021028270.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Paul Bolle wrote:

> On Tue, 2014-06-24 at 13:19 -0400, Alan Stern wrote:
> > On Tue, 24 Jun 2014, Paul Bolle wrote:
> > > On Tue, 2014-06-24 at 10:25 -0400, Alan Stern wrote:
> > > > Also, that "Later kernels" thing has already arrived.  I believe it was 
> > > > implemented in 2.6.35.
> > > 
> > > How does the kernel currently call the disconnect method? I can't yet
> > > say for sure, and it seems silly to send a v2 dropping those lines
> > > without actually knowing why they can be dropped.
> > 
> > In drivers/usb/core/driver.c:usb_resume_complete(), which is called 
> > during the final "complete" phase of system suspend, interfaces that 
> > were marked for rebinding (because their drivers didn't have proper PM 
> > support) get rebound.
> > 
> > Is that what you wanted to know?
> 
> I haven't yet discovered what the link is between rebinding and the
> "disconnect" method. I'll have to study that. This is far from urgent,
> so that might take me quite some time.

Rebinding means unbinding followed by binding.  The disconnect method 
gets called during unbinding.  The detailed call chain is:

	usb_resume_complete ->
	rebind_marked_interfaces -> 
	usb_rebind_intf ->
	usb_forced_unbind_intf ->
	usb_driver_release_interface ->
	device_release_driver ->
	__device_release_driver ->
	usb_unbind_interface ->
	disconnect.

Alan Stern


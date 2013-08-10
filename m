Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968339Ab3HJBHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 21:07:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58319 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S968309Ab3HJBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 21:07:49 -0400
Date: Fri, 9 Aug 2013 21:07:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Thomas Richter <richter@rus.uni-stuttgart.de>
cc: linux@brodo.de, <linux-kernel@vger.kernel.org>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <520577E4.4080401@rus.uni-stuttgart.de>
Message-ID: <Pine.LNX.4.44L0.1308092103320.23882-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Thomas Richter wrote:

> Hi Alan,
> 
> >> Will try and report back, thanks. I've bisected it down in the meantime
> >> to a change from 2.6.31.6 to 2.6.32.6. Interestingly, this is very much
> >> the same time when the udev userland changed. It works with 2.6.31.6 old
> >> udev, but not with 2.6.36.2, new udev.
> >
> > Can't you use the new udev with the old kernel?
> 
> Nope. udevd refuses to start and says that it requires at least 2.6.32, 
> which means that apparently something changed in the kernel-userland 
> interface in 2.6.32. Thus, my conclusion that there's probably something 
> nasty going on in userland with udev.

What about the old udev with the newer kernel?

> Here's what I got: "messages" - output from /var/log/messages. Note that 
> the mount hangs exactly at the SCSI 2A command you see there, then tries 
> to reset the device after probably 20 seconds or so.

It looks like the controller is having trouble sending the large 
packets for the write.  I have no idea why.

At this point, bisection continues to look like the best approach.  
Maybe you can confine the search to just the commits that touch files
under drivers/usb/host; then perhaps the intermediate kernels will
continue to work with the old udev.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaIROY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:24:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55639 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755660AbaIROY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:24:26 -0400
Date: Thu, 18 Sep 2014 10:24:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Petr Mladek <pmladek@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
In-Reply-To: <20140917212238.GB15795@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1409181013550.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Tejun Heo wrote:

> Hello, Alan, Petr.
> 
> On Wed, Sep 17, 2014 at 01:36:26PM -0400, Alan Stern wrote:
> > > -	/* If khubd ever becomes multithreaded, this will need a lock */
> > > +	/* If hub_wq ever becomes multithreaded, this will need a lock */
> > >  	if (udev->wusb) {
> > >  		devnum = udev->portnum + 1;
> > >  		BUG_ON(test_bit(devnum, bus->devmap.devicemap));
> > 
> > You probably didn't notice when changing this comment.  But in fact,
> > workqueues _are_ multithreaded.  Therefore you need to add a lock to 
> > this routine.
> 
> Haven't read the code but if this function is called from a single
> work_struct, workqueue guarantees that there's only single thread of
> execution at any given time.  A work item is never executed
> concurrently no matter what.

This routine can be called from multiple work_structs, because a USB 
bus can have multiple hubs.

Alan Stern


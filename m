Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHIO2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:28:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHIO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:28:40 -0400
Date: Sat, 9 Aug 2014 07:20:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergey Klyaus <Sergey.Klyaus@Tune-IT.Ru>, Oliver Neukum <oneukum@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: fix race with userland in device_add()
Message-ID: <20140809142045.GA21904@kroah.com>
References: <53E2681D.3020508@Tune-IT.Ru>
 <Pine.LNX.4.44L0.1408061610520.1145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1408061610520.1145-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:18:38PM -0400, Alan Stern wrote:
> On Wed, 6 Aug 2014, Sergey Klyaus wrote:
> 
> > Hello.
> > 
> > I wrote a patch that fixes the problem that described above, here are a 
> > patch for 3.16.0+ kernel (cloned from GitHub today). Maybe that "if 
> > (MAJOR(dev->devt)) " part has to go even after BUS_NOTIFY_ADD_DEVICE abd 
> > KOBJ_ADD? I put it before it, because there is no rollback code in 
> > device_add() for that part.
> 
> I think this is fine.  However, I suspect the order of the other calls
> there isn't totally right.  For instance, the
> 
> 	if (parent)
> 		klist_add_tail(&dev->p->knode_parent,
> 			       &parent->p->klist_children);
> 
> part should probably be the first thing after we know the routine can't 
> abort.
> 
> I guess the time when bus_probe_device() gets called doesn't matter 
> much, because the driver might not even be loaded at this point.  But 
> what about all the dev->class stuff at the end of device_add()?  Should 
> that happen before any uevents are sent out?
> 
> Greg, have you looked at this?

I haven't, thanks for pointing it out, I'll put it on my list of things
to do this week.

greg k-h

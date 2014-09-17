Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaIQQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:01:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39787 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754831AbaIQQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:01:48 -0400
Date: Wed, 17 Sep 2014 12:01:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: hub: remove obsolete while cycle in hub_event()
In-Reply-To: <20140917152453.GF2168@dhcp128.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409171159510.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Petr [iso-8859-1] Mládek wrote:

> On Fri 12-09-14 10:23:26, Alan Stern wrote:
> > On Fri, 12 Sep 2014, Petr Mladek wrote:
> > 
> > > The USB hub events are proceed by workqueue instead of kthread now.
> > > The result is that hub_event() function processes only one event.
> > > The while cycle was not removed earlier to show the real changes when
> > > switching to the workqueue.
> > > 
> > > This patch also consolidates the goto targets and rename them from "loop*"
> > > to "out*".
> > > 
> > > When touching the code, it fixes also formatting of dev_err() and dev_dbg()
> > > calls to make checkpatch.pl happy :-)
> > 
> > Although the reason given in the description above is not really
> > accurate, removing the loop in hub_events is a reasonable thing to do.  
> > That loop doesn't serve any purpose as far as I can see.
> 
> IMHO, the while cycle was needed when hub_events() was used in
> khubd thread. More events could had been added to the list before
> the thread was scheduled.

There's nothing wrong with that.  The thread would get around to 
executing the extra events in due course.

> Therefore I think that the above description makes sense.
> 
> And this is why I did not change the order of the patches in v2 of the patch
> set. I sent all patches again because this one and the 3rd one needed
> refresh.

The patch is getting close.  There are still a couple of problems 
remaining.  I'll go into more detail in another email.

Alan Stern


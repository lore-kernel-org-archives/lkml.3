Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaIQVWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:22:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62464 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaIQVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:22:44 -0400
Date: Thu, 18 Sep 2014 06:22:38 +0900
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Petr Mladek <pmladek@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
Message-ID: <20140917212238.GB15795@mtj.dyndns.org>
References: <1410967150-25240-5-git-send-email-pmladek@suse.cz>
 <Pine.LNX.4.44L0.1409171333310.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409171333310.1579-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan, Petr.

On Wed, Sep 17, 2014 at 01:36:26PM -0400, Alan Stern wrote:
> > -	/* If khubd ever becomes multithreaded, this will need a lock */
> > +	/* If hub_wq ever becomes multithreaded, this will need a lock */
> >  	if (udev->wusb) {
> >  		devnum = udev->portnum + 1;
> >  		BUG_ON(test_bit(devnum, bus->devmap.devicemap));
> 
> You probably didn't notice when changing this comment.  But in fact,
> workqueues _are_ multithreaded.  Therefore you need to add a lock to 
> this routine.

Haven't read the code but if this function is called from a single
work_struct, workqueue guarantees that there's only single thread of
execution at any given time.  A work item is never executed
concurrently no matter what.

Thanks.

-- 
tejun

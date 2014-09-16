Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaIPR4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:56:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:59130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaIPR4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,535,1406617200"; 
   d="scan'208";a="477921055"
Date: Tue, 16 Sep 2014 23:01:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: Add helper to mark last busy and autosuspend
Message-ID: <20140916173120.GT3131@intel.com>
References: <20140916153635.GS3131@intel.com>
 <Pine.LNX.4.44L0.1409161318510.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409161318510.1166-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:22:11PM -0400, Alan Stern wrote:
> On Tue, 16 Sep 2014, Vinod Koul wrote:
> 
> > > > > What's the advantage?  Removing a few bytes of source code?  There will 
> > > > > no change to the object code.  (Not to mention that your patch didn't 
> > > > > actually change _any_ of the places where both routines get called!)
> > > > Yes we didnt change users, as we need this for one of our drivers we are
> > > > trying to push.
> > > 
> > > Why do you need it?  Just change your driver to call
> > > 
> > > 	pm_runtime_mark_last_busy(dev);
> > > 	pm_runtime_put_autosuspend(dev);
> > > 
> > > instead of
> > > 
> > > 	pm_runtime_last_busy_and_autosuspend(dev);
> > > 
> > > Or create a subroutine in your driver to do this.
> > Well since this is common why not add a helper in framework!
> 
> You said this was common, but you didn't change any of the other places
> these routines get used.  I asked why and you didn't asnwer; all you
> said was that you needed it for one of your drivers.
I didnt say we wont change users either. If you do a quick search you would
see a good numbers of folks who are using above and also have their own
helpers.

> I then pointed out that you don't need it.  You didn't asnwer.
Since we have lot of users as well as my driver which we have already posted
we would like this to be in framwork
 
> I asked what advantage this change brings.  You didn't answer.
IMHO helpers like these should be part of framework rather than everyone
having their own versions!
Yes it doesnt change the object code at all, but will reduce LOC and driver
macros

Hope this explains your questions, Will come back witha a v2 with users
converted as well

-- 
~Vinod

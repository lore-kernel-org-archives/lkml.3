Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaIPPkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:40:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:63605 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaIPPkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:40:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="386886578"
Date: Tue, 16 Sep 2014 20:44:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: Add helper to mark last busy and autosuspend
Message-ID: <20140916151457.GQ3131@intel.com>
References: <1410864231-10334-1-git-send-email-subhransu.s.prusty@intel.com>
 <Pine.LNX.4.44L0.1409161024580.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409161024580.1166-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:27:53AM -0400, Alan Stern wrote:
> On Tue, 16 Sep 2014, Subhransu S. Prusty wrote:
> 
> > pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
> > in quite a lot of places. Add a helper for these.
> > 
> > Signed-off-by: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
> > ---
> >  include/linux/pm_runtime.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > index 367f49b..256ec50 100644
> > --- a/include/linux/pm_runtime.h
> > +++ b/include/linux/pm_runtime.h
> > @@ -277,4 +277,10 @@ static inline void pm_runtime_dont_use_autosuspend(struct device *dev)
> >  	__pm_runtime_use_autosuspend(dev, false);
> >  }
> >  
> > +static inline int pm_runtime_last_busy_and_autosuspend(struct device *dev)
> > +{
> > +	pm_runtime_mark_last_busy(dev);
> > +	return pm_runtime_put_autosuspend(dev);
> > +}
> > +
> >  #endif
> 
> What's the advantage?  Removing a few bytes of source code?  There will 
> no change to the object code.  (Not to mention that your patch didn't 
> actually change _any_ of the places where both routines get called!)
Yes we didnt change users, as we need this for one of our drivers we are
trying to push.

> Besides, if you're going to make an addition to the runtime PM API like 
> this, then you also have to update Documentation/power/runtime_pm.txt.
Sure if you folks are okay we can send update with Documentaion patch too

-- 
~Vinod

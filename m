Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3GML4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:56:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40094 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3GML4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:56:35 -0400
Date: Sat, 13 Jul 2013 13:56:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>, shuox.liu@intel.com,
        linux-kernel@vger.kernel.org, len.brown@intel.com, rjw@sisk.pl,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM: avoid 'autosleep' in shutdown progress
Message-ID: <20130713115631.GA16473@amd.pavel.ucw.cz>
References: <1373609651.4432.122.camel@ymzhang.sh.intel.com>
 <Pine.LNX.4.44L0.1307121034180.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307121034180.1469-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-07-12 10:37:33, Alan Stern wrote:
> On Fri, 12 Jul 2013, Yanmin Zhang wrote:
> 
> > On Thu, 2013-07-11 at 16:03 +0800, shuox.liu@intel.com wrote:
> > > From: Liu ShuoX <shuox.liu@intel.com>
> > > 
> > > In shutdown progress, system is possible to do power transition
> > > (such as suspend-to-ram) in parallel. It is unreasonable. So,
> > > fixes it by adding a system_state checking and queue try_to_suspend
> > > again when system status is not running.
> > > 
> > > Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> > > ---
> > >  kernel/power/autosleep.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > Without this patch, we hit an hang issue on Android.
> > 
> > Scenario:
> > Kernel starts shutdown and calls all device driver's shutdown callback.
> > When a driver's shutdown is called, the last wakelock is released and
> > suspend-to-ram starts. However, as some driver's shut down callbacks
> > already shut down devices and disable runtime pm, the suspend-to-ram
> > calls driver's suspend callback without noticing that device is already
> > off and causes crash.
> > We know the drivers should be fixed, but can we also change generic
> > codes a little to make it stronger?
> 
> Indeed, this does seem like the sort of thing we want to have.  
> Allowing an "automatic" or "opportunistic" sleep in the middle of a
> shutdown makes no sense at all.  In fact, it might be a good idea to
> disable system sleep completely at this time -- not even a write to
> /sys/power/state should be allowed to interrupt a shutdown.

I'm not completely sure, but as long as userland is running, we should
have system_state == RUNNING, no?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

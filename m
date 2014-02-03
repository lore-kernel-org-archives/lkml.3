Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBCQgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:36:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaBCQgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:36:35 -0500
Date: Mon, 3 Feb 2014 11:35:30 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, perf, p4: Counter corruption when using lots of
 perf groups
Message-ID: <20140203163530.GK25953@redhat.com>
References: <1391024270-19469-1-git-send-email-dzickus@redhat.com>
 <20140129200657.GJ29846@moon>
 <20140129201717.GB25953@redhat.com>
 <20140203061929.GF1850@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203061929.GF1850@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:19:29AM +0400, Cyrill Gorcunov wrote:
> On Wed, Jan 29, 2014 at 03:17:17PM -0500, Don Zickus wrote:
> > > > I am not entirely sure on the corruption path, but what happens is:
> > > > 
> > > > o perf schedules a group with p4_pmu_schedule_events()
> > > > o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
> > > >   but for a different cpu, so it 'swaps' the config bits and returns the
> > > >   updated 'assign' array with a _new_ index.
> > > > o perf schedules another group with p4_pmu_schedule_events()
> > > > o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
> > > >   (the same one as above) but for the _same_ cpu [BUG!!], so it updates the
> > > >   'assign' array to use the _old_ (wrong cpu) index because the _new_ index is in
> > > >   an earlier part of the 'assign' array (and hasn't been committed yet).
> > > > o perf commits the transaction using the wrong index and corrupts the other cpu
> > > 
> > > Thanks for the fix Don! I fear I won't be able to look precisely tonight, so
> > > could it wait until tomorrow? (If it's critical sure such fix should do the
> > > trick).
> > 
> > There is no rush.  Early next week is fine too. :-)
> 
> Hi Don, sorry for delay. I thought maybe extending match_prev_assignment()
> would be better (ie to figure out if previous event can run without
> reprogramming the counter) but this makes code only harder (and what
> is worse -- having no physical accees to p4 machine leaves no chance
> to test changes). So eventually I think your patch does the same thing
> as I had in mind but in different way. Thus
> 
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> thanks a lot!

thanks!

Cheers,
Don


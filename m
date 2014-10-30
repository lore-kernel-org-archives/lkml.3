Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbaJ3Wr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:47:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbaJ3Wry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:47:54 -0400
Date: Thu, 30 Oct 2014 23:47:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030224740.GC12706@worktop.programming.kicks-ass.net>
References: <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
 <20141030170331.GB378@htj.dyndns.org>
 <20141030214353.GB12706@worktop.programming.kicks-ass.net>
 <20141030222236.GD378@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030222236.GD378@htj.dyndns.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let me reply to just this one, I'll do the rest tomorrow, need sleeps.

On Thu, Oct 30, 2014 at 06:22:36PM -0400, Tejun Heo wrote:

> > > This controller might not even require the distinction between
> > > configured and effective tho?  Can't a new child just inherit the
> > > parent's configuration and never allow the config to become completely
> > > empty? 
> > 
> > It can do that. But that still has a problem, there is a mapping in
> > hardware which restricts the number of active configurations. The total
> > configuration space is larger than the supported active configurations.
> > 
> > So _something_ must fail. The initial proposal was mkdir failing when
> > there were more than the hardware supported active config cgroup
> > directories. The alternative was on-demand activation where we only
> > allocate the hardware resource when the first task gets moved into the
> > group -- which then clearly can fail.
> 
> Hmmm... why can't it just refuse creating a different configuration
> when its config space is full?  Make children inherit the parent's
> configuration and refuse config writes which require it to create a
> new one if the config space is full.  Seems pretty straight-forward.
> What am I missing?

We could do that I suppose, there is the one corner case that would not
allow, intermediate directories with a restricted config that also have
priv restrictions but no actual tasks. Not sure that makes sense though.

Are there any other cases I might have missed?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaKMJKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:10:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:45289 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaKMJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:10:19 -0500
Date: Thu, 13 Nov 2014 10:10:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
In-Reply-To: <20141113013707.GQ29390@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1411131008280.3935@nanos>
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com>
 <20141028082503.GN3337@twins.programming.kicks-ass.net> <5450253B.5020802@linux.intel.com> <20141029082432.GV3337@twins.programming.kicks-ass.net> <5451A94F.1090200@linux.intel.com> <alpine.DEB.2.11.1411121558280.3935@nanos>
 <20141113013707.GQ29390@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Peter Zijlstra wrote:
> On Wed, Nov 12, 2014 at 10:09:47PM +0100, Thomas Gleixner wrote:
> But sure, we can add suspend notifiers to stuff to shut down timers; I
> should have a patch for at least one of the offenders somewhere. But I
> really think that we should not be looking at the individual timers for
> this, none of the other suspend modes care about active timers.

Fair enough.
 
> > But before we do that we want a proper explanation why the interrupt
> > fires at all. The lack of explanation cleary documents that this is a
> > 'hacked it into submission' approach.
> 
> >From what I remember its the waking interrupt that ends up in the
> timekeeping code, Li should have a backtrace somwhere.

I can imagine what happens :)

> > stomp_machine() is in 99% of all use cases a clear indicator for a
> > complete design failure.
> 
> >    So the generic idle task needs a check like this:
> > 
> >    if (idle_should_freeze())
> >       	frozen_idle();
> 
> So that is adding extra code to fairly common/hot paths just for this
> one extra special case. I tried to avoid doing that.

idle enter is not that much of a hot path, really.
 
Thanks,

	tglx

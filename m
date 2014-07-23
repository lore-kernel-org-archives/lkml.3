Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaGWHZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:25:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGWHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:25:50 -0400
Message-ID: <1406100346.5076.98.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Wed, 23 Jul 2014 09:25:46 +0200
In-Reply-To: <20140723065736.GM3935@laptop>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com>
	 <1406091303.5076.33.camel@marge.simpson.net> <20140723065736.GM3935@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 08:57 +0200, Peter Zijlstra wrote: 
> On Wed, Jul 23, 2014 at 06:55:03AM +0200, Mike Galbraith wrote:
> > On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:
> > 
> > > FWIW the main problem is currently that switch-through-idle is so 
> > > slow. I think improving that would give a boost to far more
> > > situations.
> > 
> > Two high frequency idle enter/exit suckage spots:
> > 
> > 1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
> > throttle it or something.
> 
> Yeah, so the idea was to use the cpuidle idle guestimator to control
> this, and now that we've moved it somewhat closer to the scheduler that
> might become possible.
> 
> > 2) ondemand governor - tweak silly default settings to reflect the
> > reality that we routinely schedule communicating threads cross core.
> 
> Yeah, so the plan is to shoot cpufreq in the head and base the
> replacement on smp aware metrics ;-) Its on a todo list somewhere..

It never ceases to amaze me that people aren't screaming bloody murder
about those two spots.  Watching performance of lightly loaded boxen is
enough to make a grown man cry.

SUSE (and I in all of my many regression testing trees) puts tourniquets
on both of these blood spurting gashes, laptops be damned.

I also resurrect mwait_idle(), as while you may consider it obsolete, I
still love my lovely little Q6600 box (power sucking pig) dearly :)

-Mike


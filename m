Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab3EOP7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:59:21 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56487 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab3EOP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:59:20 -0400
Date: Wed, 15 May 2013 17:59:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        dzickus@redhat.com
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515155914.GC24004@somewhere>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515083729.GC10510@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:37:29AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2013 at 06:02:51PM +0200, Frederic Weisbecker wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Trying to test the nohz_full code, I was not able to get it to work.
> > Finally I enabled the tick_stop tracepoint and it showed:
> > 
> >  tick_stop:            success=no msg=perf events running
> > 
> > I talked to Frederic Weisbecker about this and he informed me that
> > perf is used by the lockup detector. I checked the code, and sure
> > enough it is.
> > 
> > As perf is always running when LOCKUP_DETECTOR is enabled, which
> > will always disable nohz_full from working, instead of confusing
> > users, disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled.
> > 
> > When perf is changed such that it does not prevent nohz_full from
> > working, then we can and should remove this constraint.
> 
> That's a bit contradictory in function, you want the NMI watchdog to
> cover all code, so disabling whilst entering NO_HZ state is going to
> make it not cover some code - *fail*.
> 
> Rather I would suggest disabling the NMI watchdog's runtime default; so
> you can still enable it with something like: 
> 
>   echo 1 > /proc/sys/kernel/nmi_watchdog
> 

Sounds good, and we then warn the user about that.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3IJJEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:04:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IJJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:04:05 -0400
Date: Tue, 10 Sep 2013 11:03:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Message-ID: <20130910090349.GN26785@twins.programming.kicks-ass.net>
References: <20130905225032.879120272@asylum.americas.sgi.com>
 <20130905225034.343366161@asylum.americas.sgi.com>
 <20130909124349.GY31370@twins.programming.kicks-ass.net>
 <522E0037.3090107@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E0037.3090107@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:07:03AM -0700, Mike Travis wrote:
> 
> 
> On 9/9/2013 5:43 AM, Peter Zijlstra wrote:
> > On Thu, Sep 05, 2013 at 05:50:41PM -0500, Mike Travis wrote:
> >> For performance reasons, the NMI handler may be disabled to lessen the
> >> performance impact caused by the multiple perf tools running concurently.
> >> If the system nmi command is issued when the UV NMI handler is disabled,
> >> the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
> >> disabled by setting the nmi disabled variable to '1'.  Setting it back to
> >> '0' will re-enable the NMI handler.
> > 
> > I'm not entirely sure why this is still needed now that you've moved all
> > really expensive bits into the UNKNOWN handler.
> > 
> 
> Yes, it could be considered optional.  My primary use was to isolate
> new bugs I found to see if my NMI changes were causing them.  But it
> appears that they are not since the problems occur with or without
> using the NMI entry into KDB.  So it can be safely removed.

OK, as a debug option it might make sense, but removing it is (of course)
fine with me ;-)

> (The basic problem is that if you hang out in KDB too long the machine
> locks up.  

Yeah, known issue. Not much you can do about it either I suspect. The
system generally isn't build for things like that.

> Other problems like the rcu stall detector does not have a
> means to be "touched" like the nmi_watchdog_timer so it fires off a
> few to many, many messages.  

That however might be easily cured if you ask Paul nicely ;-)

> Another, any network connections will time
> out if you are in KDB more than say 20 or 30 seconds.)
> 
> One other problem is with the perf tool.  It seems running more than
> about 2 or 3 perf top instances on a medium (1k cpu threads) sized
> system, they start behaving badly with a bunch of NMI stackdumps
> appearing on the console.  Eventually the system become unusable.

Yuck.. I haven't seen anything like that on the 'tiny' systems I have :/

> On a large system (4k), the perf tools get an error message (sorry
> don't have it handy at the moment) the basically implies that the
> perf config option is not set.  Again, I wanted to remove the new
> NMI handler to insure that it wasn't doing something weird, and
> it wasn't.

Cute.. 

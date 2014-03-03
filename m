Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaCCUbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:31:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbaCCUbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:31:34 -0500
Date: Mon, 3 Mar 2014 15:30:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Mario <jmario@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Davidlohr Bueso <davidlohr@hp.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303203034.GH25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
 <20140303172316.GA22728@two.firstfloor.org>
 <5314C4C4.1020304@redhat.com>
 <20140303184117.GL9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303184117.GL9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 07:41:17PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 03, 2014 at 01:07:00PM -0500, Joe Mario wrote:
> > If you only sample on the HITMs then you don't get the store misses.
> > That means you'll not be able to detect who is simultaneously tugging
> > on the same cache lines.  That gives up much of the value of "perf
> > c2c".
> 
> As long as you know which lines are hurting bringing in (loads) you can
> often figure out who is doing the stores on them.

If you are familar with the code I guess.  One scenario that would be
difficult for is shared memory (ie databases) as it may not be obvious who
is writing to a cacheline.

> 
> > As we developed this, we ended up settling on Ivy Bridge to get the
> > behavior we wanted.
> 
> Wouldn't SNB also work?

We started with SNB, but because latency info was not working (due to a GO
bug) and some other event quirks, we found ourselves migrating to a more
stable IVB platform instead.

Now that we stablized our test case and tool, SNB may work.   We just
haven't tried in along time.

Cheers,
Don


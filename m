Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaCCS60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:26 -0500
Received: from one.firstfloor.org ([193.170.194.197]:53741 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaCCS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:21 -0500
Date: Mon, 3 Mar 2014 19:58:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Mario <jmario@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303185819.GB22728@two.firstfloor.org>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Yes, especially since every store is a load too (unless you're talking
WC)

The method c2c uses is more exact, but keep in mind it's a sampling
heuristic in any cases, with some potential bias. load-latency tags
the loads randomly and there's no guarantee that tagging is fully
uniform. Also you only see a subset in any case.

> 
> > As we developed this, we ended up settling on Ivy Bridge to get the
> > behavior we wanted.
> 
> Wouldn't SNB also work?

Yes.

Haswell is best however because it can report addresses on far more
events.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbaJVUjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbaJVUjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:39:17 -0400
Date: Wed, 22 Oct 2014 16:38:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Mario <jmario@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141022203834.GL135937@redhat.com>
References: <20141022162026.GG135937@redhat.com>
 <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
 <5447F2DF.3000506@redhat.com>
 <20141022200219.GM21513@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022200219.GM21513@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:02:19PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 22, 2014 at 02:09:35PM -0400, Joe Mario wrote:
> > >Yes, kernel memory is directly addresses, you basically have a static
> > >address->node mapping, it never changes.
> > 
> > For kernel addresses, is there a reason not to have it available in perf,
> > especially when that knowledge is important to understanding a numa-related slowdown?
> 
> Dunno why that isn't exposed in sysfs.
> 
> > In our case, when we booted with one configuration, AIM ran fine.  When we
> > booted another way, AIM's performance dropped 50%.  It was all due to the dentry
> > lock being located on a different (now remote) numa node.
> > 
> > We used your dmesg approach to track down the home node in an attempt to understand
> > what was different between the two boots.  But the problem would have been obvious
> > if perf simply listed the home node info.
> 
> Or if you'd used more counters that track the node interconnect traffic
> ;-) There are a few simple ones that count local/remote type things
> (offcore), but using the uncore counters you can track way more.

Ha!  I have been telling myself for a year I would try to learn more about
those offcore/uncore counters.  Is there documentation for how to access
the uncore stuff?  Do I have to long hand it with 'perf record -e
uncore_qpi_1/<stuff>/ foo'?

Cheers,
Don


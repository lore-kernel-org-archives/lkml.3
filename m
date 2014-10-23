Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaJWLBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:01:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaJWLBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:01:30 -0400
Date: Thu, 23 Oct 2014 13:01:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Joe Mario <jmario@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141023110125.GO21513@worktop.programming.kicks-ass.net>
References: <20141022162026.GG135937@redhat.com>
 <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
 <5447F2DF.3000506@redhat.com>
 <20141022200219.GM21513@worktop.programming.kicks-ass.net>
 <20141022203834.GL135937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022203834.GL135937@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:38:34PM -0400, Don Zickus wrote:
> On Wed, Oct 22, 2014 at 10:02:19PM +0200, Peter Zijlstra wrote:

> > Or if you'd used more counters that track the node interconnect traffic
> > ;-) There are a few simple ones that count local/remote type things
> > (offcore), but using the uncore counters you can track way more.
> 
> Ha!  I have been telling myself for a year I would try to learn more about
> those offcore/uncore counters.  Is there documentation for how to access
> the uncore stuff?  Do I have to long hand it with 'perf record -e
> uncore_qpi_1/<stuff>/ foo'?

So uncore is something unholy complicated and different for each cpu,
although the newer chips seems to have limited the variation somewhat.

I would suggest you start with the offcore bits, those are in the SDM.

We have some numa cache events, but if those don't work for you you
might want to look at the offcore code we have in the kernel to help
construct your own events.

I Cc'ed you on a patch series cleaning up some of the recent HSW code.

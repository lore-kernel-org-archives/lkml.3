Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaAGXfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:35:02 -0500
Received: from one.firstfloor.org ([193.170.194.197]:37549 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaAGXew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:34:52 -0500
Date: Wed, 8 Jan 2014 00:34:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20140107233450.GG20765@two.firstfloor.org>
References: <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106221528.GK30183@twins.programming.kicks-ass.net>
 <8761pw6717.fsf@tassilo.jf.intel.com>
 <20140107083803.GM30183@twins.programming.kicks-ass.net>
 <20140107154255.GB20765@two.firstfloor.org>
 <20140107205145.GE2480@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107205145.GE2480@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 09:51:45PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 04:42:55PM +0100, Andi Kleen wrote:
> > > Yes; go read this:
> > > 
> > >  lkml.kernel.org/r/20131219125205.GT3694@twins.programming.kicks-ass.net
> > 
> > Hmm, but AFAIK we're not using freeze counters on PMI today.
> > We just rely on the explicit disabling in the counters through the global
> > ctrl.
> > 
> > So it should be the same as with any other PMI which also does not
> > automatically freeze. Not true?
> 
> Regardless whether its used or not; I'd very much like that answered.

The freeze always starts with the counter overflow, independent if the interrupt
is blocked or not. So everything should be ok.

-Andi

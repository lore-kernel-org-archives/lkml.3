Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3KOKts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:49:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3KOKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:49:40 -0500
Date: Fri, 15 Nov 2013 11:49:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131115104928.GA10456@twins.programming.kicks-ass.net>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <20131115100506.GD2965@twins.programming.kicks-ass.net>
 <CABPqkBRO=LNwHbRWKE_NnR5TUTh3sjTyp-9BOkvxQGKb2f3k7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRO=LNwHbRWKE_NnR5TUTh3sjTyp-9BOkvxQGKb2f3k7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:13:27AM +0100, Stephane Eranian wrote:
> On Fri, Nov 15, 2013 at 11:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Nov 15, 2013 at 07:34:57AM +0100, Ingo Molnar wrote:
> >> Btw., does the kernel side currently support discovery of such
> >> impossible group scheduling constraints at group setup time?
> >
> > Up to a point.
> >
> It is only looking at the group itself  not the overall condition
> of the system, e.g., the other HT thread is case of shared
> resources.
> I think all it guarantees is that if the events in the group
> are compatible with each other. And I think it covers the case
> where the events use different counters but the same shared
> resource, e.g., offcore_response on Intel X86.
> 
> >> If not
> >> then it probably should and it should reject them straight away.
> >
> > We do I think, for the case where its obvious it can never fit.
> >
> > That said, if you have a pinned cpu event, it all comes apart.
> 
> You mean in the group?

No, outside of the group, so that the above validation doesn't guarantee
actual schedulability. Yes it could all fit on the PMU in one go, but
since we _have_ to also fit this pinned task, it really will never get
scheduled.



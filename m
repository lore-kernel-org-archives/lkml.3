Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3E1Jyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:54:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54236 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3E1Jya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:54:30 -0400
Date: Tue, 28 May 2013 11:54:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130528095425.GB6764@gmail.com>
References: <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
 <20130510105536.GA18805@gmail.com>
 <20130510112756.GH31235@dyad.programming.kicks-ass.net>
 <20130511075008.GC24435@gmail.com>
 <20130513093624.GC3708@dyad.programming.kicks-ass.net>
 <20130513194313.GA30998@gmail.com>
 <CABPqkBRFMB_HUvwEXo5EK68Z6LJ9KWLNmqNBENZq-7vsP-NsrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRFMB_HUvwEXo5EK68Z6LJ9KWLNmqNBENZq-7vsP-NsrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, May 13, 2013 at 9:43 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> On Sat, May 11, 2013 at 09:50:08AM +0200, Ingo Molnar wrote:
> >> > That's really a red herring: there's absolutely no reason why the
> >> > kernel could not pass back the level of precision it provided.
> >>
> >> All I've been saying is that doing random precision without feedback is
> >> confusing.
> >
> > I agree with that.
> >
> >> We also don't really have a good feedback channel for this kind of
> >> thing. The best I can come up with is tagging each and every sample with
> >> the quality it represents. I think we can do with only one extra
> >> PERF_RECORD_MISC bit, but it looks like we're quickly running out of
> >> those things.
> >
> > Hm, how about passing precision back to user-space at creation time, in
> > the perf_attr data structure? There's no need to pass it back in every
> > sample, precision will not really change during the life-time of an event.
> >
> >> But I think the biggest problem is PEBS's inability do deal with REP
> >> prefixes; see this email from Stephane:
> >> https://lkml.org/lkml/2011/2/1/177
> >>
> >> It is really unfortunate for PEBS to have such a side-effect; but it
> >> makes all memset/memcpy/memmove things appear like they have no cost.
> >> I'm very sure that will surprise a number of people.
> >
> > I'd expect PEBS to get gradually better.
> >
> > Note that at least for user-space, REP MOVS is getting rarer. libc uses
> > SSE based memcpy/memset variants - which is not miscounted by PEBS. The
> > kernel still uses REP MOVS - but it's a special case because it cannot
> > cheaply use vector registers.
> >
> > The vast majority of code gets measured by cycles:pp more accurately than
> > cycles.
> >
> I don't understand how you come to that conclusion. [...]

By frequently looking at cycles:pp output.

> [...] I can show you simple examples where this is not true at all (even 
> without rep mov).

That would be useful if there's any practical problem with cycles:pp. In 
terms of profiling typical kernel and user space functions it does appear 
to work very well.

Thanks,

	Ingo

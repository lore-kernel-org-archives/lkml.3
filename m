Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3K2NxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab3K2NxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:53:13 -0500
Date: Fri, 29 Nov 2013 14:52:31 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131129135230.GC25751@krava.brq.redhat.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
 <20131117034134.GA19762@tassilo.jf.intel.com>
 <20131129133340.GA25751@krava.brq.redhat.com>
 <CABPqkBT5hjBJXf5VwXA=fWDj5YkjgjcsY3ef=csqVtfZZzQDHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT5hjBJXf5VwXA=fWDj5YkjgjcsY3ef=csqVtfZZzQDHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 02:43:35PM +0100, Stephane Eranian wrote:
> On Fri, Nov 29, 2013 at 2:33 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Sat, Nov 16, 2013 at 07:41:34PM -0800, Andi Kleen wrote:
> >> > I'd say that the default behavior should be what Jiri implemented: get
> >> > the most out of the situation and inform. But you are right in that
> >> > 'forcing' all elements of a group to be valid should be possible as
> >> > well - if a special perf stat option or event format is used.
> >>
> >> When something is multiplexed it can have a very
> >> large measurement error. For workloads that fluctuate quite a bit, and the
> >> fluctuations do not line up well with the multiplexing interval,
> >> the default scaling does not give good results.
> >>
> >> So you expect to get good data, but you get very bad data.
> >>
> >> When collecting data for a large number of events it is important
> >> to group them correctly, so that events that are directly dependent
> >> on each other in equations are properly grouped.
> >>
> >> When explicit groups were added the user likely considered this
> >> problem, so it's not good to silently override the choices.
> >>
> >> If a user doesn't care they can always not use groups.
> >>
> >> > Even in that second case it shouldn't say <unsupported> for everything
> >> > in the result, but should deny the run immediately and return with an
> >> > error, and should tell the user how many events in the group fit and
> >> > which ones didn't.
> >>
> >> Returning this information would be great, but it would really
> >> need an extended errno, or just a error string reported out.
> >
> > (sry for late reply, I was still ooo, and missed this conversation)
> >
> > I agree, when the last event fails sys_perf_event_open
> > due to the validate_group check, we will get just EINVAL
> >
> > Was there any discussion about the error (or erorr string)
> > propagation from sys_perf_event_open?
> >
> > Something like below? user space supply buffer for error string.
> >
> No. Why do you need kernel changes for that.
> Perf gets the error, knows it is grouping and prints an appropriate

how does perf know it's grouping and not something else?

> error message. Why do you need kernel for this?

like how would you differentiate EINVAL from validate_group or say
from set_ext_hw_attr (got by using unsupported cache event) ?

jirka

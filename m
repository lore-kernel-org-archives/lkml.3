Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3EJKzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:55:42 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55554 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3EJKzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:55:40 -0400
Date: Fri, 10 May 2013 12:55:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510105536.GA18805@gmail.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
 <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510103436.GC31235@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, May 10, 2013 at 12:31:12PM +0200, Ingo Molnar wrote:
> > PERF_COUNT_HW_CPU_CYCLES_PRECISE is not a vague request at all: it means 
> > 'get me the most precise cycles profiling available on this system'.
> 
> And how will you interpret the results? Do you know to manually adjust 
> for skid or will you assume the results 'correct'?

Look at the tools/perf/ patches, they don't actually need or use that 
information to adjust for skid!

If user-space wants _that_ level of control because it wants to correct 
for skid (if there's skid), or if it wants to display to the user how 
precise the profiling is, then they can do the (much) more complex probing 
dance.

What is absolutely indefensible is to not give a good shortcut for the 
most common case of 'give me the most precise cycles event you got'...

> I see such a feature only causing confusion; I told it to be precise, 
> therefore this register op after the memory load really is the more 
> expensive thing.

You are creating confusion where there's none: "give me the best profiling 
you've got" is a pretty reasonable thing to ask.

The thing is, there's variations in the quality of profiling between CPUs, 
sometimes even between CPU models. 99.999% of the people don't care about 
that, because 99.9% of the time the profile is unambiguous: functions are 
typically big enough, with the overhead somewhere in the middle, so skid 
just doesn't matter.

So to 'solve' this corner case information you worry about to extract 
(which cannot be solved - there's more profiling artifacts and imprecision 
than skid) you sacrifice the thing that _DOES_ matter: for the kernel to 
offer our best profiling feature as easily as possible...

What explanation do you have for that failure?

> People generally don't volunteer to think, you have to force them to -- 
> even if that makes them complain.

It is a mistake to 'force' people to consider stuff _they don't care about 
in 99% of the cases_.

Thanks,

	Ingo

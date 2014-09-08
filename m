Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaIHQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaIHQkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:40:24 -0400
Date: Mon, 8 Sep 2014 18:39:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf: Deny optimized switch for events read by
 PERF_SAMPLE_READ
Message-ID: <20140908163933.GI17728@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-3-git-send-email-jolsa@kernel.org>
 <20140902105244.GI5806@worktop.ger.corp.intel.com>
 <20140908100018.GC1172@krava.brq.redhat.com>
 <20140908101119.GB6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908101119.GB6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 12:11:19PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 12:00:19PM +0200, Jiri Olsa wrote:
> 
> > > no.. so the value of the counter is the sum of all the inherited events.
> > > It doesn't matter if you flip it or not the sum is not affected.
> > > 
> > > PERF_SAMPLE_READ should return the value.
> > 
> > so I want to be able to do the leader sampling over child processes
> > that means:
> >   - have event group with sampling leader, and the rest
> >     of the group events' periods being read on leader's sample
> >     via PERF_SAMPLE_READ sample_type
> >   - for each child process created I want it to do the
> >     same thing as the parent - sample on leader, read
> >     values of other events in group via PERF_SAMPLE_READ
> 
> The thing is, PERF_SAMPLE_READ should return the exact same thing as an
> actual read(), and for read() the value reported is the sum of all
> events.

maybe we could make this configurable? like via new per_event_attr::option bit,
keeping by default the behaviour you said

> 
> I _think_ I know what you want, and I think I see why you'd want that,
> but I'm not sure how to best do that.. Hmm.. maybe look at
> 'perf_event_attr::inherit_stat' that appears to be similar.
> 
> At which point read() vs inherit_stat might be 'broken'. Hard to know if
> anybody uses that :-(

I'll check, thanks

jirka

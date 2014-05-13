Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaEMRPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:15:03 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38391 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEMRO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:14:58 -0400
Date: Tue, 13 May 2014 19:14:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513171436.GA8672@gmail.com>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
 <5371BCF8.7030708@cn.fujitsu.com>
 <20140513100333.GW30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513100333.GW30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 13, 2014 at 03:34:32PM +0900, Dongsheng Yang wrote:
> > On 05/13/2014 04:22 PM, Ingo Molnar wrote:
> > >* Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > >>trace_sched_wakeup(.success) is a dead argument and has been for ages,
> > >Always 0, or random value?
> > 
> > Hi Ingo,
> > 
> > It is always 1 currently.
> > 
> > Peter believe that .success is not useful and I pointed that perf 
> > sched latency is using it now. Then he post this patch to remove 
> > the usage here.
> > 
> > Please go to the following link for more about this issue.
> 
> It is _not_ usable. You're proposing to abuse the existing 
> parameter. A wakeup doing an enqueue or not has nothing 
> _WHAT_SO_EVER_ to do with success.
> 
> Now what I think you wanted to do is make it easier to match 
> trace_sched_switch() statements with trace_sched_wakeup() 
> statements. And since you only get the trace_sched_switch() on 
> dequeue, you want to know which trace_sched_wakeup() calls did an 
> enqueue.
> 
> But that's completely and utterly unrelated to success.

So I always considered it 'the enqueue was successful' - that's I 
think why I added it to 'perf sched' originally - to be able to trace 
wakeups from originator to target.

Thans,

	Ingo

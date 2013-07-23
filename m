Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3GWJsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:48:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36639 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3GWJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:48:45 -0400
Date: Tue, 23 Jul 2013 11:48:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: perf: question about event scheduler
Message-ID: <20130723094832.GV27075@twins.programming.kicks-ass.net>
References: <CABPqkBSCzjjUU9i8NmscDsH+kuSQ4Cw1atahfwUBRpW-4BuaFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSCzjjUU9i8NmscDsH+kuSQ4Cw1atahfwUBRpW-4BuaFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:13:33AM +0200, Stephane Eranian wrote:
> Hi,
> 
> I am looking at ctx_pinned_sched_in() and
> ctx_flexible_sched_in() and I am trying to
> understand the difference of treatment in
> case of errors for the two classes of events
> (pinned vs. flexible).
> 
> For pinned events, when a group fails to
> schedule in, the code goes on to the next
> group and therefore walks the entire list
> for each scheduler invocation.
> 
> For flexible events, when a group fails,
> the loop aborts and no subsequent group
> is tried.
> 
> I am trying to understand the motivation for
> this difference here.
> 
> If I recall, the abort is here to limit malicious
> DoS where a malicious user would provide
> an arbitrary long list of events, hogging the kernel.
> But in the case of pinned events, this is ignored
> because to create such events one needs to be
> root in the first place.
> 
> Am I getting this right?

Whee, long time ago. I think the biggest reason is that pinned events
should always be scheduled. Not being able to schedule a pinned event is
an error. But yes, that and the fact that they're root only.



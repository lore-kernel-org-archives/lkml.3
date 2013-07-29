Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3G2JXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:23:50 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41984 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3G2JXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130723094832.GV27075@twins.programming.kicks-ass.net>
References: <CABPqkBSCzjjUU9i8NmscDsH+kuSQ4Cw1atahfwUBRpW-4BuaFw@mail.gmail.com>
	<20130723094832.GV27075@twins.programming.kicks-ass.net>
Date: Mon, 29 Jul 2013 11:23:46 +0200
Message-ID: <CABPqkBTeQeR3n_KDWffWmz0AxL8+ynfvv0tCSjPP8aCh81dgPg@mail.gmail.com>
Subject: Re: perf: question about event scheduler
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jul 23, 2013 at 10:13:33AM +0200, Stephane Eranian wrote:
> > Hi,
> >
> > I am looking at ctx_pinned_sched_in() and
> > ctx_flexible_sched_in() and I am trying to
> > understand the difference of treatment in
> > case of errors for the two classes of events
> > (pinned vs. flexible).
> >
> > For pinned events, when a group fails to
> > schedule in, the code goes on to the next
> > group and therefore walks the entire list
> > for each scheduler invocation.
> >
> > For flexible events, when a group fails,
> > the loop aborts and no subsequent group
> > is tried.
> >
> > I am trying to understand the motivation for
> > this difference here.
> >
> > If I recall, the abort is here to limit malicious
> > DoS where a malicious user would provide
> > an arbitrary long list of events, hogging the kernel.
> > But in the case of pinned events, this is ignored
> > because to create such events one needs to be
> > root in the first place.
> >
> > Am I getting this right?
>
> Whee, long time ago. I think the biggest reason is that pinned events
> should always be scheduled. Not being able to schedule a pinned event is
> an error. But yes, that and the fact that they're root only.
>
>
Ok, that's what I thought then.
Thanks,
